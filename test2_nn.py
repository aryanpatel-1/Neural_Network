import cv2
import serial
import numpy as np
import torch
from define_nn import MNISTHardwareNet # Import your exact architecture

def dual_inference_tracker():
    # 1. Load the PyTorch Model
    print("Loading PyTorch Model in Evaluation Mode...")
    model = MNISTHardwareNet()
    # Assuming you saved your model weights in train_nn.py. If you didn't, 
    # run train_model() again and save it via torch.save(model.state_dict(), 'mnist.pth')
    try:
        model.load_state_dict(torch.load('mnist.pth', weights_only=True))
    except FileNotFoundError:
        print("WARNING: 'mnist.pth' not found. You must save your trained PyTorch model to run the dual-diagnostic.")
        return
    model.eval()

    # 2. Initialize FPGA Connection
    print("Initializing serial connection on COM4...")
    ser = serial.Serial('COM4', 19200, timeout=5)

    cap = cv2.VideoCapture(0)
    canvas = np.zeros((480, 640, 3), dtype=np.uint8)
    prev_x, prev_y = 0, 0

    print("Tracker ready. Draw with the wand. Press 's' to test both networks, 'c' to clear.")

    try:
        while True:
            ret, frame = cap.read()
            frame = cv2.flip(frame, 1)

            # --- WAND TRACKING ---
            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
            mask = cv2.inRange(hsv, np.array([40,100,100]), np.array([80,255,255]))
            contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

            if contours:
                largest_contour = max(contours, key=cv2.contourArea)
                ((x, y), radius) = cv2.minEnclosingCircle(largest_contour)
                if radius > 10:
                    if prev_x == 0 and prev_y == 0:
                        prev_x, prev_y = int(x), int(y)
                    cv2.line(canvas, (prev_x, prev_y), (int(x), int(y)), (255, 255, 255), 40)
                    prev_x, prev_y = int(x), int(y)
            else:
                prev_x, prev_y = 0, 0

            combined = cv2.addWeighted(frame, 1, canvas, 1, 0)
            cv2.imshow("Wand Tracker", combined)

            key = cv2.waitKey(1) & 0xFF
            if key == ord('c'):
                canvas = np.zeros((480, 640, 3), dtype=np.uint8)
            
            elif key == ord('s'):
                gray_canvas = cv2.cvtColor(canvas, cv2.COLOR_BGR2GRAY)
                points = cv2.findNonZero(gray_canvas)

                if points is not None:
                    # --- IMAGE PREPARATION (The exact logic we fixed) ---
                    x, y, w, h = cv2.boundingRect(points)
                    cropped = gray_canvas[y:y+h, x:x+w]
                    
                    if w > h:
                        new_w, new_h = 20, int(20 * (h / w))
                    else:
                        new_w, new_h = int(20 * (w / h)), 20
                        
                    resized = cv2.resize(cropped, (new_w, new_h), interpolation=cv2.INTER_AREA)
                    blurred = cv2.GaussianBlur(resized, (3, 3), 0)
                    
                    max_val = np.max(blurred)
                    if max_val > 0:
                        normalized = (blurred / max_val * 255).astype(np.uint8)
                    else:
                        normalized = blurred

                    canvas_28 = np.zeros((28, 28), dtype=np.float32)
                    start_x, start_y = (28 - new_w) // 2, (28 - new_h) // 2
                    canvas_28[start_y:start_y+new_h, start_x:start_x+new_w] = normalized

                    m = cv2.moments(canvas_28)
                    if m["m00"] != 0:
                        cx, cy = m["m10"] / m["m00"], m["m01"] / m["m00"]
                    else:
                        cx, cy = 14.0, 14.0

                    M = np.float32([[1, 0, 14.0 - cx], [0, 1, 14.0 - cy]])
                    final_28x28 = cv2.warpAffine(canvas_28, M, (28, 28), flags=cv2.INTER_LINEAR)
                    final_28x28_uint8 = final_28x28.astype(np.uint8)

                    cv2.imshow("Vision Array", final_28x28_uint8)

                    # ==========================================
                    # TEST 1: PYTORCH INFERENCE
                    # ==========================================
                    # Scale to [0.0, 1.0] exactly like transforms.ToTensor()
                    pytorch_input = torch.tensor(final_28x28_uint8, dtype=torch.float32).flatten() / 255.0
                    
                    with torch.no_grad():
                        pytorch_logits = model(pytorch_input)
                        pytorch_prediction = torch.argmax(pytorch_logits).item()

                    # ==========================================
                    # TEST 2: FPGA INFERENCE
                    # ==========================================
                    flat_bytes = final_28x28_uint8.flatten().tobytes()
                    ser.write(flat_bytes)
                    
                    fpga_result_bytes = ser.read(1)
                    fpga_prediction = int.from_bytes(fpga_result_bytes, 'big') if len(fpga_result_bytes) > 0 else -1

                    print(f"\n--- INFERENCE RESULTS ---")
                    print(f"PyTorch Neural Net Says: {pytorch_prediction}")
                    print(f"Hardware FPGA Says     : {fpga_prediction}")
                    print(f"-------------------------")

            elif key == 27:
                break
    finally:
        ser.close()
        cap.release()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    dual_inference_tracker()