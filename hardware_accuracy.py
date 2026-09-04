import serial
import numpy as np
import time
from torchvision import datasets

def test_hardware_accuracy():
    print("Loading MNIST Test Dataset...")
    # Load the raw test dataset (no PyTorch transforms needed)
    # The C code's left-shift `<< 7` perfectly handles these raw uint8 bytes
    test_dataset = datasets.MNIST(root='./data', train=False, download=True)
    
    total_images = len(test_dataset) # 10,000 images
    correct_guesses = 0

    print("Initializing UART connection on COM4...")
    try:
        ser = serial.Serial('COM4', 230400, timeout=2)
    except Exception as e:
        print(f"Failed to open COM port: {e}")
        return

    print(f"\nBeginning Hardware Inference on {total_images} images...")
    start_time = time.time()

    for i in range(total_images):
        # 1. Get the raw image and its true label
        image, true_label = test_dataset[i]
        
        # 2. Flatten the 28x28 PIL image to 784 bytes
        flat_image = np.array(image, dtype=np.uint8).flatten()

        # 3. Send the 784 bytes to the FPGA
        ser.write(flat_image.tobytes())

        # 4. Wait for the 1-byte answer from the MicroBlaze
        result_bytes = ser.read(1)
        
        if len(result_bytes) == 0:
            print(f"\nCRITICAL ERROR: FPGA timed out on image {i}! Did the DMA hang?")
            break

        # 5. Decode the answer
        fpga_prediction = int.from_bytes(result_bytes, 'big')

        # 6. Check if the hardware was right
        if fpga_prediction == true_label:
            correct_guesses += 1

        # Print progress every 100 images so you know it hasn't frozen
        if (i + 1) % 100 == 0:
            current_acc = (correct_guesses / (i + 1)) * 100
            print(f"Processed {i + 1}/{total_images} | Running Accuracy: {current_acc:.2f}%")

    end_time = time.time()
    
    if (i + 1) == total_images:
        final_accuracy = (correct_guesses / total_images) * 100
        print("\n========================================")
        print(f"FINAL HARDWARE ACCURACY : {final_accuracy:.2f}%")
        print(f"Total Time Taken        : {(end_time - start_time):.1f} seconds")
        print("========================================")

    ser.close()

if __name__ == "__main__":
    test_hardware_accuracy()