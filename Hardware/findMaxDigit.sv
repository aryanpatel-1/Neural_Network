`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 01:22:10 PM
// Design Name: 
// Module Name: findMaxDigit
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


module findMaxDigit import nn_definitions_pkg::*; (

    input logic clk,
    input logic rst,
    
    input logic [DATA_WIDTH-1:0] s_axis_tdata,
    input logic s_axis_tvalid,
    output logic s_axis_tready,
    input logic s_axis_tlast,
    
    output logic [31:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic m_axis_tlast

    );
    
    logic [DATA_WIDTH-1:0] maxDigit;
    logic [31:0] current_index;
    logic [31:0] winning_index;
    
    
    assign s_axis_tready = !m_axis_tvalid || m_axis_tready;
    assign m_axis_tlast = m_axis_tvalid;
    assign m_axis_tdata = winning_index;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            m_axis_tvalid <= 1'b0;
            current_index <= '0;
            winning_index <= '0;
            maxDigit <= {1'b1, {(DATA_WIDTH-1){1'b0}}};
        end 
        else begin
            if (m_axis_tvalid && m_axis_tready) begin
                m_axis_tvalid <= 1'b0;
            end 
            
            if (s_axis_tvalid && s_axis_tready) begin
                if ($signed(s_axis_tdata) > $signed(maxDigit)) begin
                    maxDigit <= s_axis_tdata;
                    winning_index <= current_index;
                end
                if (s_axis_tlast) begin
                    m_axis_tvalid <= 1'b1;
                    current_index <= '0;
                    maxDigit <= {1'b1, {(DATA_WIDTH-1){1'b0}}};
                end 
                else begin
                    current_index <= current_index + 1'b1;
                end
            end  
        end 
    end 
    
endmodule
