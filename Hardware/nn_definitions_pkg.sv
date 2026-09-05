`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2026 05:22:18 PM
// Design Name: 
// Module Name: nn_definitions_pkg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

package nn_definitions_pkg;

localparam int DATA_WIDTH = 16; //16 bits of data
localparam int WEIGHT_INT_WIDTH = 1; //1 bit for integer part of weight
localparam int SIGMOID_SIZE = 5; //size of sigmoid function

localparam int NUM_INPUTS_LAYER1 = 784; //784 pixels initial inputs (28*28 from OpenCV)
localparam int NUM_INPUTS_LAYER2 = 64;
localparam int NUM_INPUTS_LAYER3 = 32;
localparam int NUM_INPUTS_LAYER4 = 10;
localparam int NUM_INPUTS_LAYER5 = 10; //Digits 0-9 

typedef enum logic [1:0] {RELU, SIGMOID, LINEAR} activation_e; //activation function Relu or Sigmoid

localparam logic IS_PRETRAINED = 1'b1; //flag for if the nn is already pre-trained

endpackage: nn_definitions_pkg
