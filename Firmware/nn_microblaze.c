
#include <stdio.h>
#include "xparameters.h"
#include "xuartlite.h"
#include "xaxidma.h"
#include "xil_cache.h"
#include "xil_io.h"

#define UART_DEVICE_ID XPAR_UARTLITE_0_DEVICE_ID
#define DMA_DEVICE_ID XPAR_AXIDMA_0_DEVICE_ID
#define NN_BASE_ADDR XPAR_NN_AXI_WRAPPER_V1_0_0_BASEADDR
#define REG_LAYER    (NN_BASE_ADDR + 0x00) // slv_reg0
#define REG_NODE     (NN_BASE_ADDR + 0x04) // slv_reg1
#define REG_ADDR     (NN_BASE_ADDR + 0x08) // slv_reg2
#define REG_DATA     (NN_BASE_ADDR + 0x0C) // slv_reg3
#define REG_CTRL     (NN_BASE_ADDR + 0x10) // slv_reg4

#define NUM_PIXELS 784

XUartLite UartLite;
XAxiDma AxiDma;

//alligned 32 byte cache line to avoid cache flushing adjacent variables in memory
u16 image_buffer[NUM_PIXELS] __attribute__((aligned(32)));
u32 result_buffer[1] __attribute__((aligned(32))); // 32-bit to match maxFinder module

int init_hardware() {
    int status = XUartLite_Initialize(&UartLite, UART_DEVICE_ID);
    if (status != XST_SUCCESS) return XST_FAILURE;

    XAxiDma_Config *CfgPtr = XAxiDma_LookupConfig(DMA_DEVICE_ID);
    status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
    if (status != XST_SUCCESS) return XST_FAILURE;

    //Disable inturrups since we are polling
    //Below saves CPU cycles that would be spent jumping to ISRs
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

    return XST_SUCCESS;
}

u16 receive_16bit_uart() {
    u8 high_byte, low_byte;
    while (XUartLite_Recv(&UartLite, &high_byte, 1) == 0);
    while (XUartLite_Recv(&UartLite, &low_byte, 1) == 0);
    return ((u16)high_byte << 8) | (u16)low_byte;
}

void write_hw_config(u32 layer, u32 node, u32 addr, u8 is_bias, u32 data) {
    //set up the address and data lines
    Xil_Out32(REG_LAYER, layer);
    Xil_Out32(REG_NODE, node);
    Xil_Out32(REG_ADDR, addr);
    Xil_Out32(REG_DATA, data);

    // write to REG_CTRL (slv_reg4)
    // change is_bias between 0 and 1
    // if is_bias = 1, ctr_val = 3, if is_bias = 0, ctr_val = 1
    u32 ctrl_val = (is_bias << 1) | 0x01;
    Xil_Out32(REG_CTRL, ctrl_val);
}

void upload_network_weights() {
    int num_layers = 4;
    int nodes_per_layer[] = {64, 32, 10, 10};
    int inputs_per_node[] = {784, 64, 32, 10};

    for (int layer_idx = 0; layer_idx < num_layers; layer_idx++) {
        u8 current_layer = layer_idx + 1;
        for (u8 node = 0; node < nodes_per_layer[layer_idx]; node++) {
            for (u16 addr = 0; addr < inputs_per_node[layer_idx]; addr++) {
                write_hw_config(current_layer, node, addr, 0, receive_16bit_uart());
            }
            write_hw_config(current_layer, node, 0, 1, receive_16bit_uart());
        }
    }
}

int main() {
    if (init_hardware() != XST_SUCCESS) {
        xil_printf("ERROR: Hardware init failed!\r\n");
        return -1;
    }

    //block and wait for Python to send weights
    upload_network_weights();

    while (1) {
        int received_pixels = 0;
        u8 raw_byte;

        //SILENTLY ingest 784 bytes
        while (received_pixels < NUM_PIXELS) {
            if (XUartLite_Recv(&UartLite, &raw_byte, 1) > 0) {
            	//left shift raw byte (0-255) by 7 (mult by 128)
            	//255*128 = 32,640
            	//Q.1.15 fixed point, 1.0 = 32,767 (0x7FFF)
            	//255 -> 0.996 in Q1.15, matching PyTorch 0.0-1.0 normalization
                image_buffer[received_pixels] = (u16)raw_byte << 7;
                received_pixels++;
            }
        }

        //Flush TX Cache
        //CPU writes to L1 cache but DMA reads from DDR/BRAM
        //Flush needed so DMA does not read stale garage from DDR/BRAM
        Xil_DCacheFlushRange((UINTPTR)image_buffer, NUM_PIXELS * sizeof(u16));

        //Arm DMA RX (4 bytes for the u32 index)
        //Need to arm receiver BEFORE transmitter
        //If TX fired first then data could be lost if RX data sent before DMA ready to catch it
        XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)result_buffer,
                               1 * sizeof(u32), XAXIDMA_DEVICE_TO_DMA);

        //Fire DMA TX
        XAxiDma_SimpleTransfer(&AxiDma, (UINTPTR)image_buffer,
                               NUM_PIXELS * sizeof(u16), XAXIDMA_DMA_TO_DEVICE);

        //Wait for hardware inference
        //Poll status registers
        //Blocks CPU until MAC finishes
        while (XAxiDma_Busy(&AxiDma, XAXIDMA_DMA_TO_DEVICE));
        while (XAxiDma_Busy(&AxiDma, XAXIDMA_DEVICE_TO_DMA));

        //Invalidate RX Cache (4 bytes)
        //DMA wrote to main mem, but CPU's L1 cache might still hold old answer from previous frame
        //Inavlid forces CPU to fetch fresh data from DDR/BRAM
        Xil_DCacheInvalidateRange((UINTPTR)result_buffer, 1 * sizeof(u32));

        //SILENTLY send the 1-byte answer back to Python
        u8 tx_byte = (u8)result_buffer[0];
        XUartLite_Send(&UartLite, &tx_byte, 1);
    }

    return 0;
}