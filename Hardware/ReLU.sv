`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 01:23:25 PM
// Design Name: 
// Module Name: ReLU
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


module ReLU import nn_definitions_pkg::*; #(parameter int DATA_WIDTH = 0)(
    input logic [DATA_WIDTH-1:0] dataIn,
    output logic [DATA_WIDTH-1:0] dataOut 
    );
    
    always_comb begin
        if (dataIn[DATA_WIDTH-1] == 1'b1) begin
            dataOut = '0;
        end 
        else begin
            dataOut = dataIn;
        end 
    end 
              
endmodule
