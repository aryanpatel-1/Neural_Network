import serial
import torch
import time
import numpy as np
from Software.define_nn import MNISTHardwareNet

# convert PyTorch float to 2-byte Q1.15 Big-Endian 
def float_to_q115_bytes(val):
    # clamp strictly to Q1.15 hardware boundaries [-1.0, 0.9999]
    if val > 0.999969:
        val = 0.999969
    elif val < -1.0:
        val = -1.0
        
    # scale by 2^15
    q115_val = int(round(val * 32768.0))
    
    # handle two's complement for negative numbers in 16-bit space
    if q115_val < 0:
        q115_val += 65536
        
    # pack into 2 bytes (Big-Endian: High byte first, Low byte second)
    # exactly C code: ((u16)high_byte << 8) | low_byte
    high_byte = (q115_val >> 8) & 0xFF
    low_byte = q115_val & 0xFF
    
    return bytes([high_byte, low_byte])

def upload_network_to_fpga():
    # load the trained PyTorch Model
    print("Loading PyTorch model weights...")
    model = MNISTHardwareNet()
    model.load_state_dict(torch.load('mnist.pth', weights_only=True))
    model.eval()

    # open the high-speed UART connection
    print("Opening serial port on COM4 at 230400 baud...")
    ser = serial.Serial('COM4', 230400, timeout=5)
    
    # give the MicroBlaze 2 seconds to boot and enter the receive loop
    time.sleep(2)
    print("\nStarting dynamic hardware configuration...\n")
    
    # extract all parameters
    params = list(model.parameters())
    num_layers = len(params) // 2
    
    # master Loop 
    for layer_idx in range(num_layers):
        layer_num = layer_idx + 1
        
        # detach tensors and convert to raw numpy arrays
        weights = params[2 * layer_idx].detach().numpy() 
        biases = params[2 * layer_idx + 1].detach().numpy() 
        
        num_nodes = weights.shape[0]
        inputs_per_node = weights.shape[1]
        
        print(f"Uploading Layer {layer_num}: {num_nodes} nodes, {inputs_per_node} inputs each...")
        
        for node in range(num_nodes):
            
            # send all weights for this specific node
            for weight_idx in range(inputs_per_node):
                w_val = float(weights[node, weight_idx])
                
                # apply the Layer 4 scaling fix to prevent hardware saturation
                if layer_num == 4:
                    w_val = w_val / 64.0
                    
                ser.write(float_to_q115_bytes(w_val))
                
            # send the single bias for this specific node
            b_val = float(biases[node])
            if layer_num == 4:
                b_val = b_val / 64.0
                
            ser.write(float_to_q115_bytes(b_val))
            
    print("\nUpload Complete.")
    ser.close()

if __name__ == "__main__":
    upload_network_to_fpga()