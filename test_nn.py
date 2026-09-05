import numpy as np
import serial
import torchvision.datasets as datasets

# load a clean sample
test_dataset = datasets.MNIST(root='./data', train=False, download=True)
image, label = test_dataset[0] # Grab the first test image (a '7')
img_np = np.array(image, dtype=np.uint8)

# scale it exactly how MicroBlaze expects it 

# send to FPGA
ser = serial.Serial('COM4', 115200) 
ser.write(uart_payload)

# read response
result = ser.read(1)
print(f"Target Label: {label} | FPGA Predicted: {int.from_bytes(result, 'big')}")