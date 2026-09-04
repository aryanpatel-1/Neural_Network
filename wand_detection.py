import cv2
import serial
import numpy as np
import sys

def run_tracker():

    # initialize serial connection
    print ("Initializing serial connection on COM4...")
    try:
            ser = serial.Serial('COM4', 230400, timeout = 5)
    except serial.serialutil.SerialException as e:
        print(f"CRITICAL ERROR: Could not open COM4. Is the FPGA plugged in?\n{e}")
        sys.exit(1)

    # start cam 
    cap = cv2.VideoCapture(0)

    # blank canvas (480x640, 3 color channels)
    canvas = np.zeros((480, 640, 3), dtype = np.uint8)

    # store prev wand positions
    prev_x = 0
    prev_y = 0

    print("Tracker ready. Draw with the green wand. Press 's' to send, 'c' to clear, ESC to quit.")

    try:
        while True:
            ret, frame = cap.read()

            # flip horiz so it acts ike a mirror
            frame = cv2.flip(frame, 1)

            # convert to HSV
            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

            # wand range 
            lower_green = np.array([40,100,100])
            upper_green = np.array([80,255,255])

            # create mask (green->white, else black)
            mask = cv2.inRange(hsv, lower_green, upper_green)

            # find boundaries of white pixels in mask
            contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

            if contours:
                # get largest contour and ignore background noise
                largest_contour = max(contours, key=cv2.contourArea)

                # find contour center using bounding circle
                ((x, y), radius) = cv2.minEnclosingCircle(largest_contour)
                x = int(x) 
                y = int(y)

                # draw if object large enough
                if radius > 10:
                    if prev_x == 0 and prev_y == 0:
                        prev_x = x
                        prev_y = y

                    stroke = cv2.line(canvas, (prev_x, prev_y), (x, y), (255, 255, 255), 40)

                    prev_x = x
                    prev_y = y
            else:
                # no wand = reset stroke
                prev_x = 0
                prev_y = 0

            # overlay canvas onto live video
            combined = cv2.addWeighted(frame, 1, canvas, 1, 0)
            cv2.imshow("Wand Tracker", combined)

            # hotkeys
            key = cv2.waitKey(1) & 0xFF

            if key == ord('c'):
                # clear canvas by overwrite with black
                canvas = np.zeros((480, 640, 3), dtype = np.uint8)
                print("Canvas cleared.")
            elif key == ord('s'):
                # send to FPGA
                print ("\nSubmitting drawing to FPGA...")

                # convert to single channel grayscale
                gray_canvas = cv2.cvtColor(canvas, cv2.COLOR_BGR2GRAY)

                #find all white pixels in image
                points = cv2.findNonZero(gray_canvas)

                if points is not None:
                    # find bounding box
                    x,y,w,h = cv2.boundingRect(points)

                    # crop the digit out
                    cropped = gray_canvas[y:y+h, x:x+w]

                    # resize preserving aspect ratio so the largest dimension is exactly 20 pixels
                    if w > h:
                        new_w = 20
                        new_h = int(20 * (h / w))
                    else:
                        new_h = 20
                        new_w = int(20 * (w / h))
                    resized = cv2.resize(cropped, (new_w, new_h), interpolation=cv2.INTER_AREA)

                    # blur and normalize (to mimic the soft-ink anti-aliasing of MNIST digits)
                    blurred = cv2.GaussianBlur(resized, (3, 3), 0)
                    max_val = np.max(blurred)
                    if max_val > 0:
                        normalized = (blurred / max_val * 255).astype(np.uint8)
                    else:
                        normalized = blurred

                    # place geometrically into a 28x28 black canvas first
                    canvas_28 = np.zeros((28, 28), dtype=np.float32) # use float for precise moments
                    start_x = (28 - new_w) // 2
                    start_y = (28 - new_h) // 2
                    canvas_28[start_y:start_y+new_h, start_x:start_x+new_w] = normalized

                    # calculate center of mass 
                    m = cv2.moments(canvas_28)
                    if m["m00"] != 0:
                        cx = m["m10"] / m["m00"]
                        cy = m["m01"] / m["m00"]
                    else:
                        cx, cy = 14.0, 14.0

                    # translate so the c.o.m rest at (14.0, 14.0)
                    dx = 14.0 - cx
                    dy = 14.0 - cy
                    M = np.float32([[1, 0, dx], [0, 1, dy]])

                    # warp affine to apply the sub-pixel shift
                    final_28x28 = cv2.warpAffine(canvas_28, M, (28, 28), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=0)

                    # convert back to uint8 for UART transmission
                    final_28x28 = final_28x28.astype(np.uint8)
                    cv2.imshow("FPGA Vision", final_28x28)

                    # flatten to 1D array of 784 bytes
                    flat_image = final_28x28.flatten().astype(np.uint8)
                    print(f"Sending exactly {len(flat_image)} bytes to FPGA at 230400 baud...")

                    # convert array to bytes then write to port
                    ser.write(flat_image.tobytes())
                    ser.flush()

                    # catch FPGA output
                    print("Waiting for FPGA response...")
                    fpga_result_bytes = ser.read(1000) # read up to 1000 bytes

                    if len(fpga_result_bytes) > 0:
                        print("\n--- FPGA DEBUG OUTPUT ---")
                        # Decode the bytes into text so you can read the xil_printf checkpoints
                        print(fpga_result_bytes.decode('utf-8', errors='ignore'))
                        print("-------------------------\n")
                    else:
                        print("ERROR: 5-second timeout reached! The FPGA never sent a reply.") 
                
            elif key == 27:
                # ESC to quit
                print("Exiting...")
                break
    finally:
        print("Releasing hardware locks...")
        if 'ser' in locals() and ser.is_open:
            ser.close()
        cap.release()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    run_tracker()