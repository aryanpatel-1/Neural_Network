`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2026 01:19:17 PM
// Design Name: 
// Module Name: display_AXI_Wrapper
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


module display_AXI_Wrapper(

    input logic clk,
    input logic rst,
    
    input  logic [31:0] s_axis_tdata,
    input  logic s_axis_tvalid,
    
    output logic [3:0] anode,   // Active-low digit select
    output logic [7:0] cathode  // Active-low segment mapping (A-G, DP)

    );
    
    logic [3:0] held_digit;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            held_digit <= 4'hF;
        end 
        else if (s_axis_tvalid) begin
            // The classification is always 0-9, which fits perfectly in 4 bits
            held_digit <= s_axis_tdata[3:0]; 
        end
    end
    
    assign anode = 4'b1110; 

    always_comb begin
        case (held_digit)
            // Cathode mapping: {DP, G, F, E, D, C, B, A}
            // 0 means the LED segment is ON.
            4'h0: cathode = 8'b1100_0000; 
            4'h1: cathode = 8'b1111_1001; 
            4'h2: cathode = 8'b1010_0100; 
            4'h3: cathode = 8'b1011_0000; 
            4'h4: cathode = 8'b1001_1001; 
            4'h5: cathode = 8'b1001_0010; 
            4'h6: cathode = 8'b1000_0010; 
            4'h7: cathode = 8'b1111_1000; 
            4'h8: cathode = 8'b1000_0000; 
            4'h9: cathode = 8'b1001_0000;
            4'hF: cathode = 8'b1111_1111; 
            default: cathode = 8'b1111_1111; // Turn off if out of bounds
        endcase
    end
        
endmodule
