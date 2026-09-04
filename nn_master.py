from train_nn import train_model
from weights_and_biases import generate_files
from wand_detection import run_tracker

def main():
    # phase 1: train the PyTorch model
    print("\n[Phase 1] Training Neural Network on MNIST...")
    trained_model = train_model()
    
    # phase 2: export Q1.15 Weights for Vivado
    print("\n[Phase 2] Generating .mif Hardware Weights...")
    # Pass the smart model we just trained into your conversion script
    generate_files(trained_model)
    
    # phase 3: launch computer vision & UART communication
    print("\n[Phase 3] Booting OpenCV Tracker & UART Comms...")
    # This will open your webcam and start talking to the board
    run_tracker()
    
    print("\nPipeline Terminated.")

if __name__ == "__main__":
    main()