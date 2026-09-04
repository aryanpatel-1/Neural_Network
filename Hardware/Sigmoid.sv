`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 02:08:29 PM
// Design Name: 
// Module Name: Sigmoid
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


module Sigmoid import nn_definitions_pkg::*; #(parameter int DATA_WIDTH = 0, parameter int SIGMOID_SIZE = 0)(

    input clk,
    input logic [DATA_WIDTH-1:0] dataIn,
    input logic [DATA_WIDTH-1:0] dataOut
    );
    
    logic [DATA_WIDTH-1:0] memory [0 : (1 << SIGMOID_SIZE)-1];
    logic [SIGMOID_SIZE-1:0] dataAddress;
    logic [SIGMOID_SIZE-1:0] truncated_input;
    
    initial
    begin
        $readmemb("sigmoid_content.mif", memory);
    end
    
    assign truncated_input = dataIn[DATA_WIDTH-1 : DATA_WIDTH-SIGMOID_SIZE];
    
    assign dataAddress = {~truncated_input[SIGMOID_SIZE-1], truncated_input[SIGMOID_SIZE-2:0]};
    
    assign dataOut = memory[dataAddress];
      
endmodule
