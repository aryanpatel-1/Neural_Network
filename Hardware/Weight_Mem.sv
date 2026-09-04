`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2026 06:36:53 PM
// Design Name: 
// Module Name: Weight_Mem
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


module Weight_Mem import nn_definitions_pkg::*; 
  #(parameter Weight_num=1, 
    parameter addressWidth=1, 
    parameter dataWidth=1, 
    parameter weightFile= "w_1_1.mif"
    )
    (
    input logic clk,
    
    input logic write_enable,
    input logic read_enable,
    
    input logic [addressWidth-1:0] write_address,
    input logic [addressWidth-1:0] read_address,
    
    input logic [dataWidth-1:0] write_in,
    output logic [dataWidth-1:0] write_out
    );
    
    logic [dataWidth-1:0] memory [Weight_num-1:0]; //memory array
    
    //Read
    always_ff @(posedge clk) begin
        if(read_enable) begin
            write_out <= memory[read_address];
        end
    end 
    
    //burn pretrained weights at bootup OR write in new weights if write enable
    //possible due to 'generate' -> BRAM or ROM -> preserves Fmax and resources
    generate 
        if (IS_PRETRAINED == 1'b1) initial begin 
            $readmemh(weightFile, memory);
        end 
        else begin 
            always_ff @(posedge clk) begin
                if (write_enable) begin
                    memory[write_address] <= write_in;
                end
            end
        end
    endgenerate
            
endmodule
