`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2026 06:00:43 PM
// Design Name: 
// Module Name: tb_Layer_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_Layer_1(

    );
    
    // ==========================================
    // 1. SIGNAL DECLARATIONS
    // ==========================================
    // Assuming 16-bit data width as defined in your architecture
    localparam DATA_WIDTH  = 16;
    localparam NUM_PIXELS  = 784;
    localparam NUM_NEURONS = 32;

    logic clk;
    logic rst;

    // AXI-Lite Config (Tied to 0 for this test, assuming weights are in ROM .mif files)
    logic [31:0] config_layer_num = '0;
    logic [31:0] config_node_num = '0;
    logic [31:0] config_addr = '0;
    logic [DATA_WIDTH-1:0] config_data = '0;
    logic config_en = 1'b0;
    logic config_is_bias = 1'b0;

    // AXI-Stream Input (Mimicking the Transmit DMA)
    logic [DATA_WIDTH-1:0] s_axis_tdata;
    logic s_axis_tvalid;
    logic s_axis_tready;

    // AXI-Stream Output (Mimicking Layer 2 / Receive DMA)
    logic [DATA_WIDTH-1:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready;
    logic m_axis_tlast;

    // ==========================================
    // 2. DEVICE UNDER TEST (DUT)
    // ==========================================
    Layer_1 dut (
        .clk(clk),
        .rst(rst),
        
        .config_layer_num(config_layer_num),
        .config_node_num(config_node_num),
        .config_addr(config_addr),
        .config_data(config_data),
        .config_en(config_en),
        .config_is_bias(config_is_bias),
        
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast)
    );

    // ==========================================
    // 3. CLOCK GENERATION (100 MHz)
    // ==========================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // ==========================================
    // 4. MAIN TEST SEQUENCE
    // ==========================================
    initial begin
        // Initialize signals
        rst = 1'b1;
        s_axis_tdata = '0;
        s_axis_tvalid = 1'b0;
        m_axis_tready = 1'b1; // We are always ready to catch the output

        // Hold reset for 50ns, then release
        #50;
        rst = 1'b0;
        #50;

        $display("--- Starting DMA Image Transfer ---");

        // Fire 784 pixels sequentially into Layer 1
        s_axis_tvalid = 1'b1;
        for (int i = 0; i < NUM_PIXELS; i++) begin
            // For testing, we just send the pixel index as the data
            // In a real test, you'd read a text file containing an actual MNIST image
            s_axis_tdata = DATA_WIDTH'(i); 

            // Wait for 1 clock edge
            @(posedge clk);
            
            // If the layer pulls tready low, we must pause and wait!
            while (!s_axis_tready) begin
                @(posedge clk);
            end
        end
        
        // Stop transmitting once 784 pixels are sent
        s_axis_tvalid = 1'b0;
        $display("--- Image Transfer Complete. Waiting for Computation ---");

        // Wait for the layer to finish computing and start streaming the 32 answers
        wait(m_axis_tvalid == 1'b1);
        
        $display("--- Computation Complete. Catching Outputs ---");
        
        // Read out all 32 sequential outputs
        for (int n = 0; n < NUM_NEURONS; n++) begin
            @(posedge clk);
            if (m_axis_tvalid && m_axis_tready) begin
                $display("Neuron %0d Output: %d", n, $signed(m_axis_tdata));
            end
            
            if (m_axis_tlast) begin
                $display("Received tlast flag! Stream finished.");
                break;
            end
        end

        #100;
        $display("--- SIMULATION SUCCESS ---");
        $finish;
    end
endmodule
