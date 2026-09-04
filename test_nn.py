import numpy as np
import serial
import torchvision.datasets as datasets

# Load a clean sample you know the answer to
test_dataset = datasets.MNIST(root='./data', train=False, download=True)
image, label = test_dataset[0] # Grab the first test image (a '7')
img_np = np.array(image, dtype=np.uint8)

# Scale it exactly how your MicroBlaze expects it (if your C code does << 7, send raw uint8)
uart_payload = img_np.flatten().tobytes()

# Send to FPGA
ser = serial.Serial('COM4', 115200) # Match your baud rate
ser.write(uart_payload)

# Read response
result = ser.read(1)
print(f"Target Label: {label} | FPGA Predicted: {int.from_bytes(result, 'big')}")