import numpy as np
import os

DATA_WIDTH = 16
FRACTIONAL_BITS = 15  # Q1.15 format (1 sign bit, 15 fractional)

# map layers and nodes
architecture = {
    1: (784, 64),
    2: (64, 32),
    3: (32, 10),
    4: (10, 10)
}

# fixed point conversion
def float_to_hex_q1_15(val):
    """Converts a float to a 16-bit Q1.15 hex string using 2's complement."""
    
    # calculate bounds for 16-bit signed integer
    max_val = (1 << (DATA_WIDTH - 1)) - 1  # 32767
    min_val = -(1 << (DATA_WIDTH - 1))     # -32768
    
    # scale the float by 2^15 and round to nearest integer
    int_val = int(round(val * (1 << FRACTIONAL_BITS)))
    
    # clamp values to prevent overflow hardware crashes
    if int_val > max_val: int_val = max_val
    if int_val < min_val: int_val = min_val
    
    # convert negative numbers to 16-bit 2's complement
    if int_val < 0:
        int_val = (1 << DATA_WIDTH) + int_val
        
    # format as 4 character uppercase hex
    return f"{int_val:04X}"

# generate files
def generate_files(trained_model):
    output_dir = "mif_files"
    os.makedirs(output_dir, exist_ok=True)
    
    print(f"Generating Hex initialization files in '/{output_dir}'...")

    trained_model.eval()
    
    for layer_num, (num_inputs, num_nodes) in architecture.items():

        # dynamically grab PyTorch layer
        layer_name = f"layer{layer_num}"
        pytorch_layer = getattr(trained_model, layer_name)

        # extract the entire weight matrix and bias vector for this layer
        all_weights = pytorch_layer.weight.detach().numpy()
        all_biases = pytorch_layer.bias.detach().numpy()

        for node in range(num_nodes):

            node_weights = all_weights[node]
            node_bias = all_biases[node]

            if layer_num == 4:
                # divide by 64 to guarantee all logits fit safely inside [-1.0, 0.9999]
                node_weights = node_weights / 64.0
                node_bias = node_bias / 64.0
            
            # write weight file 
            weight_filename = os.path.join(output_dir, f"w_{layer_num}_{node}.mif")
            with open(weight_filename, "w") as f:
                for w in node_weights:
                    f.write(float_to_hex_q1_15(w) + "\n")
                    
            # write bias file
            bias_filename = os.path.join(output_dir, f"b_{layer_num}_{node}.mif")
            with open(bias_filename, "w") as f:
                f.write(float_to_hex_q1_15(node_bias) + "\n")
                
    print("Generation complete. Total files created:", sum(v[1] * 2 for v in architecture.values()))

if __name__ == "__main__":
    generate_files()