`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2026 01:48:07 PM
// Design Name: 
// Module Name: Node
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


module Node import nn_definitions_pkg::*; 
#(parameter int Layer_num = 0, parameter int Node_num = 0, parameter int Weight_num = 0,
  parameter int WEIGHT_INT_WIDTH = 1, 
  parameter SIGMOID_SIZE = 5, parameter actType = RELU,
  parameter weightFile = "", parameter biasFile = ""
  )
  (
    input logic clk,
    input logic rst,
    
    input  logic config_en,      // Write enable from MicroBlaze
    input  logic  config_is_bias, // 0 = write weight, 1 = write bias
    input  logic [$clog2(Weight_num)-1:0] config_addr,    // Which weight to update
    input  logic [DATA_WIDTH-1:0] config_data,    // The new weight/bias value
    
    input logic [DATA_WIDTH-1:0] givenInput,
    input logic givenInputValid,
    output logic [DATA_WIDTH-1:0] out,
    output logic outValid
  );
  
  logic [DATA_WIDTH-1:0] givenInputDelayed;
  logic [DATA_WIDTH-1:0] weight_out;
  logic [$clog2(Weight_num):0] read_address;
  
  (* use_dsp = "yes" *)logic [2*DATA_WIDTH-1:0] multipliedInput;
  (* use_dsp = "yes" *)logic [2*DATA_WIDTH-1:0] multipliedInput_pipe;
  localparam int ACCUM_WIDTH = 48;
  logic [ACCUM_WIDTH-1:0] summedInput;
  logic [2*DATA_WIDTH-1:0] bias;
  logic [DATA_WIDTH-1:0] config_bias;
  logic [ACCUM_WIDTH-1:0] next_sum;
  
  logic [3:0] valid_pipeline;
  logic [DATA_WIDTH-1:0] biasRegister; 
  
  logic last_pixel_flag;
  logic last_pixel_delayed_1; 
  logic last_pixel_delayed_2;
  logic last_pixel_delayed_3;
  
  logic [DATA_WIDTH-1:0] pre_activation_data;
  
  Weight_Mem #(
    .Weight_num(Weight_num), 
    .addressWidth($clog2(Weight_num)), 
    .dataWidth(DATA_WIDTH), 
    .weightFile(weightFile)
    ) 
    weight_mem_inst
    (
    .clk(clk),
    .write_enable(config_en && !config_is_bias && !IS_PRETRAINED),
    .read_enable(givenInputValid),
    .write_address(config_addr),
    .read_address(read_address[$clog2(Weight_num)-1:0]),
    .write_in(config_data),
    .write_out(weight_out)
    );
    
    always_ff @(posedge clk) begin 
        if (rst || outValid) begin
            read_address <= '0;
            valid_pipeline <= '0;
        end 
        else begin 
            if(givenInputValid) begin
                read_address <= read_address + 1'b1;
            end 
            
            valid_pipeline <= {valid_pipeline[2:0], givenInputValid};
        end
    end 
    
    always_ff @(posedge clk) begin
        if (rst) begin
            config_bias <= '0;
        end 
        else if (config_en && config_is_bias) begin
            config_bias <= config_data;
        end 
    end
    
    always_ff @(posedge clk) begin
        if (givenInputValid) begin
            givenInputDelayed <= givenInput;
        end 
        if (valid_pipeline[0]) begin
            multipliedInput <= ($signed(givenInputDelayed) * $signed(weight_out));
        end
        if (valid_pipeline[1]) begin
            multipliedInput_pipe <= multipliedInput;
        end
    end 
    
    generate 
        if (IS_PRETRAINED == 1'b1) begin : gen_pretrained
            logic [DATA_WIDTH-1:0] biasRegister [0:1];
            initial begin
                $readmemh(biasFile, biasRegister);
            end 
            always_comb begin
                bias = {{WEIGHT_INT_WIDTH{biasRegister[0][DATA_WIDTH-1]}}, biasRegister[0], {(DATA_WIDTH - WEIGHT_INT_WIDTH){1'b0}}};
            end
        end
        else begin : gen_dynamic 
            always_comb begin
                bias = {{WEIGHT_INT_WIDTH{config_bias[DATA_WIDTH-1]}}, config_bias, {(DATA_WIDTH - WEIGHT_INT_WIDTH){1'b0}}};
            end 
        end 
    endgenerate
    
    always_comb begin : accum_logic
        logic [ACCUM_WIDTH-1:0] mult_ext;
        
        // Sign-extend the 32-bit Q2.30 multiplier result to 48-bit Q18.30
        mult_ext = {{ (ACCUM_WIDTH - 2*DATA_WIDTH){multipliedInput_pipe[2*DATA_WIDTH-1]} }, multipliedInput_pipe};
        
        // FIX 2: Simply add the multiplier. The bias is already pre-loaded into summedInput.
        next_sum = summedInput + mult_ext;
    end : accum_logic
    
    always_ff@(posedge clk) begin
        if (rst || outValid) begin
            // FIX 2: Pre-load the accumulator with the sign-extended bias on reset
            summedInput <= {{ (ACCUM_WIDTH - 2*DATA_WIDTH){bias[2*DATA_WIDTH-1]} }, bias};
        end 
        else if (valid_pipeline[3]) begin
            summedInput <= next_sum;
        end
    end

    always_ff @(posedge clk) begin
        if (rst || outValid) begin
            last_pixel_delayed_1 <= 1'b0;
            last_pixel_delayed_2 <= 1'b0;
            last_pixel_delayed_3 <= 1'b0;
        end else begin
            // Flag goes high only on the exact cycle the last input is read
            last_pixel_flag <= (read_address == Weight_num - 1) && givenInputValid;
            
            if (valid_pipeline[0]) begin
                last_pixel_delayed_1 <= last_pixel_flag;
            end
            if (valid_pipeline[1]) begin 
                last_pixel_delayed_2 <= last_pixel_delayed_1;
            end 
            if (valid_pipeline[2]) begin  
                last_pixel_delayed_3 <= last_pixel_delayed_2;
            end 
        end
    end
    
    always_ff @(posedge clk) begin
        if (rst || outValid) begin
            outValid <= 1'b0; // Correctly assigning the 1-bit flag
        end 
        else if (valid_pipeline[3] && last_pixel_delayed_3) begin
            outValid <= 1'b1;
        end
    end
   
    always_comb begin : downcast_logic
        if (summedInput[47:30] != 18'h00000 && summedInput[47:30] != 18'h3FFFF) begin
            if (summedInput[47] == 1'b0) begin
                // Positive Overflow: Clamp to +0.9999
                pre_activation_data = {1'b0, {(DATA_WIDTH-1){1'b1}}}; 
            end else begin
                // Negative Underflow: Clamp to -1.0000
                pre_activation_data = {1'b1, {(DATA_WIDTH-1){1'b0}}}; 
            end
        end else begin
            // Safe to extract using your original slice formula
            pre_activation_data = summedInput[DATA_WIDTH + (DATA_WIDTH - WEIGHT_INT_WIDTH) - 1 : (DATA_WIDTH - WEIGHT_INT_WIDTH)];
        end
    end : downcast_logic               
    
    generate 
        if (actType == RELU) begin : gen_relu
            ReLU #(.DATA_WIDTH(DATA_WIDTH)) relu_instance (.dataIn(pre_activation_data), .dataOut(out));
        end 
        else if (actType == SIGMOID) begin : gen_sigmoid
            Sigmoid #(.DATA_WIDTH(DATA_WIDTH), .SIGMOID_SIZE(SIGMOID_SIZE)) sigmoid_instance (.clk(clk), .dataIn(pre_activation_data), .dataOut(out)); 
        end
        else if (actType == LINEAR) begin : gen_linear
            assign out = pre_activation_data;
        end 
    endgenerate 
    
endmodule