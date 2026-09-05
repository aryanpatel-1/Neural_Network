![SystemVerilog](https://img.shields.io/badge/SystemVerilog-000000?style=for-the-badge&logo=siemens&logoColor=white)
![C](https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PyTorch](https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=pytorch&logoColor=white)
![OpenCV](https://img.shields.io/badge/OpenCV-5C3EE8?style=for-the-badge&logo=opencv&logoColor=white)
![Xilinx](https://img.shields.io/badge/Xilinx_Vivado-232F3E?style=for-the-badge&logo=xilinx&logoColor=white)

# FPGA Hardware AI Accelerator: Real-Time MNIST Inference

A custom full-stack hardware AI accelerator deployed on a Xilinx Spartan-7 FPGA (Urbana Board). This project implements a fully connected Multi-Layer Perceptron (MLP) from scratch in SystemVerilog, integrated with a PyTorch/OpenCV software frontend and a MicroBlaze bare-metal C backend.

The system bypasses soft-processor bottlenecks by offloading all neural network computation to a custom hardware pipeline via AXI4-Stream and Direct Memory Access (DMA), achieving high-speed, real-time handwritten digit 
recognition using Q1.15 fixed-point arithmetic.

## Demo
https://github.com/user-attachments/assets/df5ce00f-0f1d-4757-a75f-7fc2e3e7b6e8

## Block Diagram
<img width="1652" height="2044" alt="nn_bd drawio" src="https://github.com/user-attachments/assets/0a9abeeb-d45e-4ca8-83f1-c1bddaec2cd0" />

## Repository Structure
<pre>
├── Firmware/
│   └── nn_microblaze.c                 # Bare-metal MicroBlaze driver for DMA, UART, and L1 cache management
├── Hardware/
│   ├── NeuralNet_Top.sv                # Top-level AXI4-Stream wrapper for the MLP pipeline
│   ├── Node.sv                         # Core DSP multiply-accumulate (MAC) logic and pipelining
│   ├── ReLU.sv                         # Combinational hardware ReLU activation and clamping
│   ├── Sigmoid.sv                      # LUT-based Q1.15 hardware Sigmoid activation
│   ├── Weight_Mem.sv                   # Dual-boot BRAM instantiation for static/dynamic weight loading
│   ├── display_AXI_Wrapper.sv          # Active-low 7-segment display driver for Urbana board
│   ├── findMaxDigit.sv                 # Sequential comparator to determine the final classification
│   ├── neuralnet.xdc                   # Physical pin constraints for clock, UART, and displays
│   ├── nn_axi_wrapper_v1_0_S00_AXI.v   # AXI4-Lite slave wrapper for configuration registers
│   ├── nn_definitions_pkg.sv           # Global hardware parameters and Q1.15 bounds
│   ├── tb_Layer_1.sv                   # SystemVerilog testbench for layer-level DSP validation
│   └── tb_NeuralNet_top.sv             # Top-level integration testbench for the full pipeline
├── Software/
│   ├── define_nn.py                    # PyTorch model architecture definition
│   ├── generate_sigmoid.py             # Python script to compute Q1.15 Sigmoid LUT values
│   ├── hardware_accuracy.py            # UART script to validate FPGA inference accuracy against MNIST test set
│   ├── nn_layer_generator.py           # Script to dynamically generate SystemVerilog Layer_X.sv files
│   ├── nn_master.py                    # Master pipeline runner (train -> generate hex -> run tracker)
│   ├── real_time_weights_and_biases.py # Dynamic UART weight injection utility
│   ├── test2_nn.py                     # Local software inference testing script
│   ├── test_nn.py                      # Local software inference testing script
│   ├── train_nn.py                     # PyTorch training loop with Q1.15 tensor clamping
│   ├── wand_detection.py               # OpenCV center-of-mass green wand tracker and UART transmitter
│   └── weights_and_biases.py           # Q1.15 Hex / .mif initialization file generator
├── .gitignore                          # Git ignore rules for build artifacts and weights
└── README.md                           # Project documentation
</pre>

## 1. Performance Metrics & Hardware Efficiency

*   **Clock Frequency ($F_{max}$):** 104 MHz. The pipeline uses inferred DSP48 slices and BRAMs, carefully registered to prevent combinational logic from violating setup/hold times.
*   **Throughput:** ~20 Frames Per Second (FPS) real-time inference, bounded primarily by the 230.4k baud UART transmission time of the 784-byte input frame, rather than the hardware compute time.
*   **Accuracy:** Matches the baseline PyTorch evaluation accuracy. Because the PyTorch training loop enforces a strict `[-1.0, 0.9999]` tensor clamp, the quantization error when transitioning from 32-bit floating-point to hardware 16-bit Q1.15 arithmetic is negligible, ensuring the hardware performs exactly as simulated in software.

## 2. Software Frontend: PyTorch Training & Computer Vision

The software stack handles model training, weight quantization, and real-time data ingestion.

*   **Constrained PyTorch Training:** The neural network (784 → 64 → 32 → 10 → 10) is trained in PyTorch. To mimic hardware constraints, gradients are calculated normally, but weights are strictly clamped between `[-1.0, 0.9999]` (the bounds of Q1.15 fixed-point format) after every optimization step.
*   **Saturating Pre-scaling:** To prevent integer overflow in the final hardware layer, the Layer 4 weights and biases are statically scaled down by a factor of 64 before being converted to hex initialization files (`.mif`).
*   **OpenCV Center-of-Mass Tracking:** A physical green wand is tracked using HSV masking. The script extracts the bounding box, resizes the longest edge to 20 pixels, and applies a Gaussian blur to mimic soft-ink anti-aliasing.
*   **Sub-Pixel Alignment:** The OpenCV script calculates the geometric center of mass using Image Moments (`cv2.moments`), computes the affine translation matrix, and warps the digit so its mass rests precisely at `(14.0, 14.0)` on a 28x28 canvas—matching the exact spatial alignment of the training data before UART transmission.

## 3. Firmware: MicroBlaze & DMA Orchestration

The bare-metal C application running on the MicroBlaze soft processor acts as a low-overhead orchestrator, moving data between UART, DDR/BRAM memory, and the custom AXI hardware peripheral.

*   **Polling Over Interrupts:** ISRs are explicitly disabled (`XAxiDma_IntrDisable`) in favor of tight polling loops, saving CPU cycles that would otherwise be spent context-switching during high-frequency frame ingestion.
*   **UART Data Shifting:** As the MicroBlaze reads the 784 raw 8-bit pixel values, it dynamically maps them to the Q1.15 16-bit space by left-shifting the bytes by 7 (`<< 7`). This efficiently normalizes an input of `255` to `32640` (`0.996`), matching PyTorch's `0.0 - 1.0` distribution without expensive floating-point division.
*   **L1 Cache Coherency:** Because the CPU writes the normalized image buffer to its L1 Cache, but the AXI DMA engine reads directly from main memory, the firmware executes an explicit `Xil_DCacheFlushRange` before arming the DMA. After inference, `Xil_DCacheInvalidateRange` forces the CPU to fetch the fresh classification from main memory.

## 4. Hardware: SystemVerilog ML Pipeline

The custom SystemVerilog hardware pipeline handles the mathematical execution of the neural network.

*   **DSP-Accelerated Compute Nodes (`Node.sv`):** The core multiply-accumulate (MAC) logic is synthesized directly into dedicated DSP slices using the `(* use_dsp = "yes" *)` attribute, ensuring single-cycle multiplication. A 4-stage shift register pipeline perfectly matches the BRAM read latency, maintaining continuous data flow.
*   **Dynamic Reconfiguration & Pre-training:** The `Weight_Mem.sv` modules support a dual-boot architecture using `generate` blocks. Weights can be statically burned into BRAM at synthesis via `.mif` files to maximize $F_{max}$, or dynamically injected node-by-node from the Python frontend over UART via memory-mapped configuration registers.
*   **Max Finder & Display:** The final layer streams logits into `findMaxDigit.sv`, which sequentially compares incoming Q1.15 values against a registered maximum. On the `tlast` signal, the winning index is transmitted back to the DMA and simultaneously tapped by `display_AXI_Wrapper.sv` to drive the active-low 7-segment display on the Urbana board.

## 5. Data Representation & Fixed-Point Math

This architecture relies entirely on a custom Q1.15 fixed-point math engine, as floating-point arithmetic is prohibitively expensive on FPGAs.

*   **Format:** 16-bit word length: 1 Sign bit, 15 Fractional bits. Value range: `[-1.0, 0.9999]`.
*   **48-Bit Accumulation Engine:** To prevent overflow during summation, the 32-bit Q2.30 multiplier results are sign-extended to a 48-bit Q18.30 accumulator register. The accumulator is pre-loaded with the node's bias during the reset/idle state to eliminate a separate addition cycle.
*   **Downcast Clamping Logic:** After a node finishes accumulating, the hardware checks the upper 18 integer bits (`summedInput[47:30]`). If they indicate an overflow/underflow, combinational logic intercepts and clamps the output to either `+0.9999` (`16'h7FFF`) or `-1.0000` (`16'h8000`), ensuring mathematical stability before passing the data to the activation modules.

## 7. Project Authorship & Tooling

**All core engineering decisions, system architecture, data paths, PyTorch mathematical bounds, and SystemVerilog RTL modules were conceptualized, written, and validated by me.**

Generative AI (LLMs) was utilized in this project strictly as a supplementary workflow tool. Its application was limited to:
*   Generating boilerplate documentation (including structuring this README based on my provided specifications).
*   Acting as a sounding board during debugging sessions (e.g., parsing Vivado implementation warnings or troubleshooting Python UART timing issues).
*   Writing repetitive Python formatting scripts (such as the `.mif` file hex generator).

Using AI as a specialized assistant allowed me to spend less time on boilerplate scripting and more time optimizing the critical DSP paths, clock domain logic, and fixed-point mathematical stability of the physical hardware.

## 8. Getting Started

Prerequisites
Hardware: Xilinx Spartan-7 FPGA (Urbana Board), Standard Webcam.
Software: Xilinx Vivado and Vitis, Python 3.8+.
Python Packages: torch, torchvision, opencv-python, pyserial, numpy.

## Train Model and Generate Hardware Weights
Run the master training pipeline to generate the PyTorch model and export the .mif (Memory Initialization Files) required for Vivado BRAM synthesis.

cd Software
python nn_master.py

## Hardware Synthesis (Vivado)

Create a new Vivado Block Design.

Instantiate a MicroBlaze processor, AXI Uartlite (set to 230400 baud), and AXI DMA.

Package the Hardware directory as a custom AXI4-Stream IP and add it to the block design.

Add the generated .mif files to the project sources.

Run Synthesis, Implementation, and generate the Bitstream.

## Firmware Deployment (Vitis)

Export the hardware .xsa from Vivado and create a new Vitis bare-metal application.

Replace the default source with Firmware/nn_microblaze.c.
If using pretrained weights/biases, comment out "upload_network_weights()" helper.

Build the project and program the FPGA. 

cd Software
python wand_detection.py

Run the Real-Time Tracker
Launch the computer vision frontend. Use a green object to draw a digit in the camera frame, and press s to send the payload to the FPGA for hardware inference, press c to clear the drawing, and Esc to quit.