module Layer_1 import nn_definitions_pkg::*; (
    input logic clk,
    input logic rst,

    input logic config_en,
    input logic config_is_bias,
    input logic config_layer_num,
    input logic config_node_num,
    input logic [$clog2(NUM_INPUTS_LAYER1)-1:0] config_addr,
    input logic [16-1:0] config_data,

    input logic s_axis_tvalid,
    output logic s_axis_tready,
    input logic [16-1:0] s_axis_tdata,

    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic [16-1:0] m_axis_tdata,
    output logic m_axis_tlast
);

logic [64-1:0][16-1:0] internal_data_out;
logic [64-1:0] internal_out_valid;
logic is_sending;

logic [64-1:0][16-1:0] shift_reg;
logic [$clog2(64):0] shift_count;

assign s_axis_tready = 1'b1;

assign m_axis_tdata = shift_reg[0];
assign m_axis_tlast = (shift_count == 1) && m_axis_tvalid;

    Node #(
        .Layer_num(1), .Node_num(0), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_0.mif"),
        .biasFile("b_1_0.mif")
    ) n_0 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 0)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[0]),
        .outValid(internal_out_valid[0])
    );

    Node #(
        .Layer_num(1), .Node_num(1), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_1.mif"),
        .biasFile("b_1_1.mif")
    ) n_1 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 1)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[1]),
        .outValid(internal_out_valid[1])
    );

    Node #(
        .Layer_num(1), .Node_num(2), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_2.mif"),
        .biasFile("b_1_2.mif")
    ) n_2 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 2)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[2]),
        .outValid(internal_out_valid[2])
    );

    Node #(
        .Layer_num(1), .Node_num(3), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_3.mif"),
        .biasFile("b_1_3.mif")
    ) n_3 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 3)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[3]),
        .outValid(internal_out_valid[3])
    );

    Node #(
        .Layer_num(1), .Node_num(4), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_4.mif"),
        .biasFile("b_1_4.mif")
    ) n_4 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 4)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[4]),
        .outValid(internal_out_valid[4])
    );

    Node #(
        .Layer_num(1), .Node_num(5), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_5.mif"),
        .biasFile("b_1_5.mif")
    ) n_5 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 5)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[5]),
        .outValid(internal_out_valid[5])
    );

    Node #(
        .Layer_num(1), .Node_num(6), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_6.mif"),
        .biasFile("b_1_6.mif")
    ) n_6 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 6)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[6]),
        .outValid(internal_out_valid[6])
    );

    Node #(
        .Layer_num(1), .Node_num(7), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_7.mif"),
        .biasFile("b_1_7.mif")
    ) n_7 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 7)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[7]),
        .outValid(internal_out_valid[7])
    );

    Node #(
        .Layer_num(1), .Node_num(8), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_8.mif"),
        .biasFile("b_1_8.mif")
    ) n_8 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 8)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[8]),
        .outValid(internal_out_valid[8])
    );

    Node #(
        .Layer_num(1), .Node_num(9), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_9.mif"),
        .biasFile("b_1_9.mif")
    ) n_9 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 9)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[9]),
        .outValid(internal_out_valid[9])
    );

    Node #(
        .Layer_num(1), .Node_num(10), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_10.mif"),
        .biasFile("b_1_10.mif")
    ) n_10 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 10)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[10]),
        .outValid(internal_out_valid[10])
    );

    Node #(
        .Layer_num(1), .Node_num(11), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_11.mif"),
        .biasFile("b_1_11.mif")
    ) n_11 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 11)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[11]),
        .outValid(internal_out_valid[11])
    );

    Node #(
        .Layer_num(1), .Node_num(12), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_12.mif"),
        .biasFile("b_1_12.mif")
    ) n_12 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 12)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[12]),
        .outValid(internal_out_valid[12])
    );

    Node #(
        .Layer_num(1), .Node_num(13), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_13.mif"),
        .biasFile("b_1_13.mif")
    ) n_13 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 13)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[13]),
        .outValid(internal_out_valid[13])
    );

    Node #(
        .Layer_num(1), .Node_num(14), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_14.mif"),
        .biasFile("b_1_14.mif")
    ) n_14 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 14)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[14]),
        .outValid(internal_out_valid[14])
    );

    Node #(
        .Layer_num(1), .Node_num(15), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_15.mif"),
        .biasFile("b_1_15.mif")
    ) n_15 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 15)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[15]),
        .outValid(internal_out_valid[15])
    );

    Node #(
        .Layer_num(1), .Node_num(16), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_16.mif"),
        .biasFile("b_1_16.mif")
    ) n_16 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 16)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[16]),
        .outValid(internal_out_valid[16])
    );

    Node #(
        .Layer_num(1), .Node_num(17), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_17.mif"),
        .biasFile("b_1_17.mif")
    ) n_17 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 17)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[17]),
        .outValid(internal_out_valid[17])
    );

    Node #(
        .Layer_num(1), .Node_num(18), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_18.mif"),
        .biasFile("b_1_18.mif")
    ) n_18 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 18)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[18]),
        .outValid(internal_out_valid[18])
    );

    Node #(
        .Layer_num(1), .Node_num(19), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_19.mif"),
        .biasFile("b_1_19.mif")
    ) n_19 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 19)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[19]),
        .outValid(internal_out_valid[19])
    );

    Node #(
        .Layer_num(1), .Node_num(20), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_20.mif"),
        .biasFile("b_1_20.mif")
    ) n_20 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 20)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[20]),
        .outValid(internal_out_valid[20])
    );

    Node #(
        .Layer_num(1), .Node_num(21), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_21.mif"),
        .biasFile("b_1_21.mif")
    ) n_21 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 21)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[21]),
        .outValid(internal_out_valid[21])
    );

    Node #(
        .Layer_num(1), .Node_num(22), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_22.mif"),
        .biasFile("b_1_22.mif")
    ) n_22 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 22)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[22]),
        .outValid(internal_out_valid[22])
    );

    Node #(
        .Layer_num(1), .Node_num(23), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_23.mif"),
        .biasFile("b_1_23.mif")
    ) n_23 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 23)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[23]),
        .outValid(internal_out_valid[23])
    );

    Node #(
        .Layer_num(1), .Node_num(24), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_24.mif"),
        .biasFile("b_1_24.mif")
    ) n_24 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 24)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[24]),
        .outValid(internal_out_valid[24])
    );

    Node #(
        .Layer_num(1), .Node_num(25), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_25.mif"),
        .biasFile("b_1_25.mif")
    ) n_25 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 25)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[25]),
        .outValid(internal_out_valid[25])
    );

    Node #(
        .Layer_num(1), .Node_num(26), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_26.mif"),
        .biasFile("b_1_26.mif")
    ) n_26 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 26)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[26]),
        .outValid(internal_out_valid[26])
    );

    Node #(
        .Layer_num(1), .Node_num(27), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_27.mif"),
        .biasFile("b_1_27.mif")
    ) n_27 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 27)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[27]),
        .outValid(internal_out_valid[27])
    );

    Node #(
        .Layer_num(1), .Node_num(28), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_28.mif"),
        .biasFile("b_1_28.mif")
    ) n_28 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 28)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[28]),
        .outValid(internal_out_valid[28])
    );

    Node #(
        .Layer_num(1), .Node_num(29), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_29.mif"),
        .biasFile("b_1_29.mif")
    ) n_29 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 29)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[29]),
        .outValid(internal_out_valid[29])
    );

    Node #(
        .Layer_num(1), .Node_num(30), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_30.mif"),
        .biasFile("b_1_30.mif")
    ) n_30 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 30)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[30]),
        .outValid(internal_out_valid[30])
    );

    Node #(
        .Layer_num(1), .Node_num(31), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_31.mif"),
        .biasFile("b_1_31.mif")
    ) n_31 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 31)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[31]),
        .outValid(internal_out_valid[31])
    );

    Node #(
        .Layer_num(1), .Node_num(32), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_32.mif"),
        .biasFile("b_1_32.mif")
    ) n_32 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 32)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[32]),
        .outValid(internal_out_valid[32])
    );

    Node #(
        .Layer_num(1), .Node_num(33), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_33.mif"),
        .biasFile("b_1_33.mif")
    ) n_33 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 33)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[33]),
        .outValid(internal_out_valid[33])
    );

    Node #(
        .Layer_num(1), .Node_num(34), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_34.mif"),
        .biasFile("b_1_34.mif")
    ) n_34 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 34)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[34]),
        .outValid(internal_out_valid[34])
    );

    Node #(
        .Layer_num(1), .Node_num(35), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_35.mif"),
        .biasFile("b_1_35.mif")
    ) n_35 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 35)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[35]),
        .outValid(internal_out_valid[35])
    );

    Node #(
        .Layer_num(1), .Node_num(36), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_36.mif"),
        .biasFile("b_1_36.mif")
    ) n_36 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 36)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[36]),
        .outValid(internal_out_valid[36])
    );

    Node #(
        .Layer_num(1), .Node_num(37), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_37.mif"),
        .biasFile("b_1_37.mif")
    ) n_37 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 37)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[37]),
        .outValid(internal_out_valid[37])
    );

    Node #(
        .Layer_num(1), .Node_num(38), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_38.mif"),
        .biasFile("b_1_38.mif")
    ) n_38 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 38)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[38]),
        .outValid(internal_out_valid[38])
    );

    Node #(
        .Layer_num(1), .Node_num(39), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_39.mif"),
        .biasFile("b_1_39.mif")
    ) n_39 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 39)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[39]),
        .outValid(internal_out_valid[39])
    );

    Node #(
        .Layer_num(1), .Node_num(40), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_40.mif"),
        .biasFile("b_1_40.mif")
    ) n_40 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 40)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[40]),
        .outValid(internal_out_valid[40])
    );

    Node #(
        .Layer_num(1), .Node_num(41), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_41.mif"),
        .biasFile("b_1_41.mif")
    ) n_41 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 41)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[41]),
        .outValid(internal_out_valid[41])
    );

    Node #(
        .Layer_num(1), .Node_num(42), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_42.mif"),
        .biasFile("b_1_42.mif")
    ) n_42 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 42)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[42]),
        .outValid(internal_out_valid[42])
    );

    Node #(
        .Layer_num(1), .Node_num(43), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_43.mif"),
        .biasFile("b_1_43.mif")
    ) n_43 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 43)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[43]),
        .outValid(internal_out_valid[43])
    );

    Node #(
        .Layer_num(1), .Node_num(44), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_44.mif"),
        .biasFile("b_1_44.mif")
    ) n_44 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 44)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[44]),
        .outValid(internal_out_valid[44])
    );

    Node #(
        .Layer_num(1), .Node_num(45), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_45.mif"),
        .biasFile("b_1_45.mif")
    ) n_45 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 45)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[45]),
        .outValid(internal_out_valid[45])
    );

    Node #(
        .Layer_num(1), .Node_num(46), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_46.mif"),
        .biasFile("b_1_46.mif")
    ) n_46 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 46)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[46]),
        .outValid(internal_out_valid[46])
    );

    Node #(
        .Layer_num(1), .Node_num(47), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_47.mif"),
        .biasFile("b_1_47.mif")
    ) n_47 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 47)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[47]),
        .outValid(internal_out_valid[47])
    );

    Node #(
        .Layer_num(1), .Node_num(48), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_48.mif"),
        .biasFile("b_1_48.mif")
    ) n_48 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 48)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[48]),
        .outValid(internal_out_valid[48])
    );

    Node #(
        .Layer_num(1), .Node_num(49), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_49.mif"),
        .biasFile("b_1_49.mif")
    ) n_49 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 49)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[49]),
        .outValid(internal_out_valid[49])
    );

    Node #(
        .Layer_num(1), .Node_num(50), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_50.mif"),
        .biasFile("b_1_50.mif")
    ) n_50 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 50)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[50]),
        .outValid(internal_out_valid[50])
    );

    Node #(
        .Layer_num(1), .Node_num(51), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_51.mif"),
        .biasFile("b_1_51.mif")
    ) n_51 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 51)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[51]),
        .outValid(internal_out_valid[51])
    );

    Node #(
        .Layer_num(1), .Node_num(52), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_52.mif"),
        .biasFile("b_1_52.mif")
    ) n_52 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 52)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[52]),
        .outValid(internal_out_valid[52])
    );

    Node #(
        .Layer_num(1), .Node_num(53), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_53.mif"),
        .biasFile("b_1_53.mif")
    ) n_53 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 53)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[53]),
        .outValid(internal_out_valid[53])
    );

    Node #(
        .Layer_num(1), .Node_num(54), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_54.mif"),
        .biasFile("b_1_54.mif")
    ) n_54 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 54)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[54]),
        .outValid(internal_out_valid[54])
    );

    Node #(
        .Layer_num(1), .Node_num(55), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_55.mif"),
        .biasFile("b_1_55.mif")
    ) n_55 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 55)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[55]),
        .outValid(internal_out_valid[55])
    );

    Node #(
        .Layer_num(1), .Node_num(56), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_56.mif"),
        .biasFile("b_1_56.mif")
    ) n_56 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 56)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[56]),
        .outValid(internal_out_valid[56])
    );

    Node #(
        .Layer_num(1), .Node_num(57), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_57.mif"),
        .biasFile("b_1_57.mif")
    ) n_57 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 57)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[57]),
        .outValid(internal_out_valid[57])
    );

    Node #(
        .Layer_num(1), .Node_num(58), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_58.mif"),
        .biasFile("b_1_58.mif")
    ) n_58 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 58)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[58]),
        .outValid(internal_out_valid[58])
    );

    Node #(
        .Layer_num(1), .Node_num(59), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_59.mif"),
        .biasFile("b_1_59.mif")
    ) n_59 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 59)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[59]),
        .outValid(internal_out_valid[59])
    );

    Node #(
        .Layer_num(1), .Node_num(60), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_60.mif"),
        .biasFile("b_1_60.mif")
    ) n_60 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 60)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[60]),
        .outValid(internal_out_valid[60])
    );

    Node #(
        .Layer_num(1), .Node_num(61), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_61.mif"),
        .biasFile("b_1_61.mif")
    ) n_61 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 61)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[61]),
        .outValid(internal_out_valid[61])
    );

    Node #(
        .Layer_num(1), .Node_num(62), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_62.mif"),
        .biasFile("b_1_62.mif")
    ) n_62 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 62)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[62]),
        .outValid(internal_out_valid[62])
    );

    Node #(
        .Layer_num(1), .Node_num(63), .Weight_num(NUM_INPUTS_LAYER1),
        .weightFile("w_1_63.mif"),
        .biasFile("b_1_63.mif")
    ) n_63 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 1) && (config_node_num == 63)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[63]),
        .outValid(internal_out_valid[63])
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
                shift_count <= 64;
                is_sending <= 1'b1;
                m_axis_tvalid <= 1'b1;
            end 
            else if (is_sending && m_axis_tready && m_axis_tvalid) begin
                if (shift_count == 1) begin
                    is_sending <= 1'b0;
                    m_axis_tvalid <= 1'b0;
                end else begin
                    for (int i = 0; i < 63; i++) begin
                        shift_reg[i] <= shift_reg[i+1];
                    end 
                    shift_count <= shift_count - 1'b1;
                end 
            end 
        end 
    end 

endmodule
