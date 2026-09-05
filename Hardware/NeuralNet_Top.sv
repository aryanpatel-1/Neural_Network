`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 01:38:05 PM
// Design Name: 
// Module Name: NeuralNet_Top
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


module NeuralNet_Top import nn_definitions_pkg::*;(

    input logic clk,
    input logic rst,
    
    input  logic [31:0] config_layer_num,
    input  logic [31:0] config_node_num,
    input  logic [31:0] config_addr,
    input  logic [DATA_WIDTH-1:0] config_data,
    input  logic config_en,
    input  logic config_is_bias,
    
    input  logic [DATA_WIDTH-1:0] s_axis_tdata,
    input  logic s_axis_tvalid,
    output logic s_axis_tready,
    
    output logic [DATA_WIDTH-1:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input  logic m_axis_tready,
    output logic m_axis_tlast,
    
    output logic [3:0] anode,
    output logic [7:0] cathode

    );
    
    logic [DATA_WIDTH-1:0] L1_tdata;
    logic L1_tvalid;
    logic L1_tready;
    logic L1_tlast;
    
    logic [DATA_WIDTH-1:0] L2_tdata;
    logic L2_tvalid;
    logic L2_tready;
    logic L2_tlast;
    
    logic [DATA_WIDTH-1:0] L3_tdata;
    logic L3_tvalid;
    logic L3_tready;
    logic L3_tlast;
    
    logic [DATA_WIDTH-1:0] L4_tdata;
    logic L4_tvalid;
    logic L4_tready;
    logic L4_tlast;
    
    Layer_1 l1 (
        .clk(clk), .rst(rst),
        .config_layer_num(config_layer_num), .config_node_num(config_node_num),
        .config_addr(config_addr), .config_data(config_data),
        .config_en(config_en), .config_is_bias(config_is_bias),
        
        // Input comes from the Top-Level (DMA)
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        
        // Output goes to Layer 2
        .m_axis_tdata(L1_tdata),
        .m_axis_tvalid(L1_tvalid),
        .m_axis_tready(L1_tready),
        .m_axis_tlast(L1_tlast)
    );

    Layer_2 l2 (
        .clk(clk), .rst(rst),
        .config_layer_num(config_layer_num), .config_node_num(config_node_num),
        .config_addr(config_addr), .config_data(config_data),
        .config_en(config_en), .config_is_bias(config_is_bias),
        
        // Input comes from Layer 1
        .s_axis_tdata(L1_tdata),
        .s_axis_tvalid(L1_tvalid),
        .s_axis_tready(L1_tready),
        
        // Output goes to Layer 3
        .m_axis_tdata(L2_tdata),
        .m_axis_tvalid(L2_tvalid),
        .m_axis_tready(L2_tready),
        .m_axis_tlast(L2_tlast)
    );

    Layer_3 l3 (
        .clk(clk), .rst(rst),
        .config_layer_num(config_layer_num), .config_node_num(config_node_num),
        .config_addr(config_addr), .config_data(config_data),
        .config_en(config_en), .config_is_bias(config_is_bias),
        
        // Input comes from Layer 2
        .s_axis_tdata(L2_tdata),
        .s_axis_tvalid(L2_tvalid),
        .s_axis_tready(L2_tready),
        
        // Output goes to Layer 4
        .m_axis_tdata(L3_tdata),
        .m_axis_tvalid(L3_tvalid),
        .m_axis_tready(L3_tready),
        .m_axis_tlast(L3_tlast)
    );

    Layer_4 l4 (
        .clk(clk), .rst(rst),
        .config_layer_num(config_layer_num), .config_node_num(config_node_num),
        .config_addr(config_addr), .config_data(config_data),
        .config_en(config_en), .config_is_bias(config_is_bias),
        
        // Input comes from Layer 3
        .s_axis_tdata(L3_tdata),
        .s_axis_tvalid(L3_tvalid),
        .s_axis_tready(L3_tready),
        
        // Output goes to maxFinder
        .m_axis_tdata(L4_tdata),
        .m_axis_tvalid(L4_tvalid),
        .m_axis_tready(L4_tready),
        .m_axis_tlast(L4_tlast)
    );
    
    findMaxDigit max (
        .clk(clk),
        .rst(rst),
        
        // Input comes from Layer 4
        .s_axis_tdata(L4_tdata),
        .s_axis_tvalid(L4_tvalid),
        .s_axis_tready(L4_tready),
        .s_axis_tlast(L4_tlast), // Crucial: Tells maxFinder when to finalize
        
        // Final Output goes to the Top-Level (DMA)
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast)
    );
    
    display_AXI_Wrapper digit_display (
        .clk(clk),
        .rst(rst),
        
        // Tap into the maxFinder's output wires
        .s_axis_tdata(m_axis_tdata),
        .s_axis_tvalid(m_axis_tvalid),
        
        // Route to the external top-level pins
        .anode(anode),
        .cathode(cathode)
    );
       
endmodule
