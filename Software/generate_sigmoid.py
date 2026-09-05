import math

def generate_sigmoid_mif():
    DATA_WIDTH = 16
    SIGMOID_SIZE = 5
    LUT_ENTRIES = 1 << SIGMOID_SIZE  # 2^Sigmoid_size addresses 
    HALF_LUT = 1 << (SIGMOID_SIZE - 1)
    
    with open("sigmoid_content.mif", "w") as f:
        for addr in range(LUT_ENTRIES):
            
            # reverse the hardware address mapping
            N = addr - HALF_LUT
            
            # convert to Q1.15 Floating Point
            x = N / float(HALF_LUT)
            
            # calculate True Sigmoid
            sig_x = 1.0 / (1.0 + math.exp(-x))
            
            # scale to Q1.15 Fixed-Point (multiply by 32768)
            q115_val = int(round(sig_x * 32768.0))
            
            # 5. Hardware Safety Clamping
            if q115_val > 32767:
                q115_val = 32767
            elif q115_val < 0:
                q115_val = 0
                
            # format as 16-bit binary string for $readmemb
            bin_str = format(q115_val, '016b')
            
            f.write(f"{bin_str}\n")
            
    print(f"Successfully generated sigmoid_content.mif with {LUT_ENTRIES} entries.")

if __name__ == "__main__":
    generate_sigmoid_mif()