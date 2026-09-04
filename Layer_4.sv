module Layer_4 import nn_definitions_pkg::*; (
    input logic clk,
    input logic rst,

    input logic config_en,
    input logic config_is_bias,
    input logic config_layer_num,
    input logic config_node_num,
    input logic [$clog2(NUM_INPUTS_LAYER4)-1:0] config_addr,
    input logic [16-1:0] config_data,

    input logic s_axis_tvalid,
    output logic s_axis_tready,
    input logic [16-1:0] s_axis_tdata,

    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic [16-1:0] m_axis_tdata,
    output logic m_axis_tlast
);

logic [10-1:0][16-1:0] internal_data_out;
logic [10-1:0] internal_out_valid;
logic is_sending;

logic [10-1:0][16-1:0] shift_reg;
logic [$clog2(10):0] shift_count;

assign s_axis_tready = 1'b1;

assign m_axis_tdata = shift_reg[0];
assign m_axis_tlast = (shift_count == 1) && m_axis_tvalid;

    Node #(
        .Layer_num(4), .Node_num(0), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_0.mif"),
        .biasFile("b_4_0.mif")
    ) n_0 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 0)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[0]),
        .outValid(internal_out_valid[0])
    );

    Node #(
        .Layer_num(4), .Node_num(1), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_1.mif"),
        .biasFile("b_4_1.mif")
    ) n_1 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 1)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[1]),
        .outValid(internal_out_valid[1])
    );

    Node #(
        .Layer_num(4), .Node_num(2), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_2.mif"),
        .biasFile("b_4_2.mif")
    ) n_2 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 2)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[2]),
        .outValid(internal_out_valid[2])
    );

    Node #(
        .Layer_num(4), .Node_num(3), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_3.mif"),
        .biasFile("b_4_3.mif")
    ) n_3 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 3)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[3]),
        .outValid(internal_out_valid[3])
    );

    Node #(
        .Layer_num(4), .Node_num(4), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_4.mif"),
        .biasFile("b_4_4.mif")
    ) n_4 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 4)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[4]),
        .outValid(internal_out_valid[4])
    );

    Node #(
        .Layer_num(4), .Node_num(5), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_5.mif"),
        .biasFile("b_4_5.mif")
    ) n_5 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 5)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[5]),
        .outValid(internal_out_valid[5])
    );

    Node #(
        .Layer_num(4), .Node_num(6), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_6.mif"),
        .biasFile("b_4_6.mif")
    ) n_6 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 6)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[6]),
        .outValid(internal_out_valid[6])
    );

    Node #(
        .Layer_num(4), .Node_num(7), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_7.mif"),
        .biasFile("b_4_7.mif")
    ) n_7 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 7)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[7]),
        .outValid(internal_out_valid[7])
    );

    Node #(
        .Layer_num(4), .Node_num(8), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_8.mif"),
        .biasFile("b_4_8.mif")
    ) n_8 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 8)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[8]),
        .outValid(internal_out_valid[8])
    );

    Node #(
        .Layer_num(4), .Node_num(9), .Weight_num(NUM_INPUTS_LAYER4),
        .weightFile("w_4_9.mif"),
        .biasFile("b_4_9.mif")
    ) n_9 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 4) && (config_node_num == 9)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[9]),
        .outValid(internal_out_valid[9])
    );


    always_ff @(posedge clk) begin
        if (rst) begin
            is_sending <= 1'b0;
            m_axis_tvalid <= 1'b0;
            shift_count <= '0;
        end 
        else begin
            if (internal_out_valid[0] && !is_sending) begin
                shift_reg <= internal_data_out;
                shift_count <= 10;
                is_sending <= 1'b1;
                m_axis_tvalid <= 1'b1;
            end 
            else if (is_sending && m_axis_tready && m_axis_tvalid) begin
                if (shift_count == 1) begin
                    is_sending <= 1'b0;
                    m_axis_tvalid <= 1'b0;
                end else begin
                    for (int i = 0; i < 9; i++) begin
                        shift_reg[i] <= shift_reg[i+1];
                    end 
                    shift_count <= shift_count - 1'b1;
                end 
            end 
        end 
    end 

endmodule
