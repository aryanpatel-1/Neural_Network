module Layer_2 import nn_definitions_pkg::*; (
    input logic clk,
    input logic rst,

    input logic config_en,
    input logic config_is_bias,
    input logic config_layer_num,
    input logic config_node_num,
    input logic [$clog2(NUM_INPUTS_LAYER2)-1:0] config_addr,
    input logic [16-1:0] config_data,

    input logic s_axis_tvalid,
    output logic s_axis_tready,
    input logic [16-1:0] s_axis_tdata,

    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic [16-1:0] m_axis_tdata,
    output logic m_axis_tlast
);

logic [32-1:0][16-1:0] internal_data_out;
logic [32-1:0] internal_out_valid;
logic is_sending;

logic [32-1:0][16-1:0] shift_reg;
logic [$clog2(32):0] shift_count;

assign s_axis_tready = 1'b1;

assign m_axis_tdata = shift_reg[0];
assign m_axis_tlast = (shift_count == 1) && m_axis_tvalid;

    Node #(
        .Layer_num(2), .Node_num(0), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_0.mif"),
        .biasFile("b_2_0.mif")
    ) n_0 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 0)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[0]),
        .outValid(internal_out_valid[0])
    );

    Node #(
        .Layer_num(2), .Node_num(1), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_1.mif"),
        .biasFile("b_2_1.mif")
    ) n_1 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 1)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[1]),
        .outValid(internal_out_valid[1])
    );

    Node #(
        .Layer_num(2), .Node_num(2), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_2.mif"),
        .biasFile("b_2_2.mif")
    ) n_2 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 2)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[2]),
        .outValid(internal_out_valid[2])
    );

    Node #(
        .Layer_num(2), .Node_num(3), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_3.mif"),
        .biasFile("b_2_3.mif")
    ) n_3 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 3)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[3]),
        .outValid(internal_out_valid[3])
    );

    Node #(
        .Layer_num(2), .Node_num(4), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_4.mif"),
        .biasFile("b_2_4.mif")
    ) n_4 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 4)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[4]),
        .outValid(internal_out_valid[4])
    );

    Node #(
        .Layer_num(2), .Node_num(5), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_5.mif"),
        .biasFile("b_2_5.mif")
    ) n_5 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 5)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[5]),
        .outValid(internal_out_valid[5])
    );

    Node #(
        .Layer_num(2), .Node_num(6), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_6.mif"),
        .biasFile("b_2_6.mif")
    ) n_6 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 6)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[6]),
        .outValid(internal_out_valid[6])
    );

    Node #(
        .Layer_num(2), .Node_num(7), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_7.mif"),
        .biasFile("b_2_7.mif")
    ) n_7 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 7)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[7]),
        .outValid(internal_out_valid[7])
    );

    Node #(
        .Layer_num(2), .Node_num(8), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_8.mif"),
        .biasFile("b_2_8.mif")
    ) n_8 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 8)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[8]),
        .outValid(internal_out_valid[8])
    );

    Node #(
        .Layer_num(2), .Node_num(9), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_9.mif"),
        .biasFile("b_2_9.mif")
    ) n_9 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 9)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[9]),
        .outValid(internal_out_valid[9])
    );

    Node #(
        .Layer_num(2), .Node_num(10), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_10.mif"),
        .biasFile("b_2_10.mif")
    ) n_10 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 10)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[10]),
        .outValid(internal_out_valid[10])
    );

    Node #(
        .Layer_num(2), .Node_num(11), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_11.mif"),
        .biasFile("b_2_11.mif")
    ) n_11 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 11)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[11]),
        .outValid(internal_out_valid[11])
    );

    Node #(
        .Layer_num(2), .Node_num(12), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_12.mif"),
        .biasFile("b_2_12.mif")
    ) n_12 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 12)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[12]),
        .outValid(internal_out_valid[12])
    );

    Node #(
        .Layer_num(2), .Node_num(13), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_13.mif"),
        .biasFile("b_2_13.mif")
    ) n_13 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 13)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[13]),
        .outValid(internal_out_valid[13])
    );

    Node #(
        .Layer_num(2), .Node_num(14), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_14.mif"),
        .biasFile("b_2_14.mif")
    ) n_14 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 14)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[14]),
        .outValid(internal_out_valid[14])
    );

    Node #(
        .Layer_num(2), .Node_num(15), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_15.mif"),
        .biasFile("b_2_15.mif")
    ) n_15 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 15)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[15]),
        .outValid(internal_out_valid[15])
    );

    Node #(
        .Layer_num(2), .Node_num(16), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_16.mif"),
        .biasFile("b_2_16.mif")
    ) n_16 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 16)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[16]),
        .outValid(internal_out_valid[16])
    );

    Node #(
        .Layer_num(2), .Node_num(17), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_17.mif"),
        .biasFile("b_2_17.mif")
    ) n_17 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 17)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[17]),
        .outValid(internal_out_valid[17])
    );

    Node #(
        .Layer_num(2), .Node_num(18), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_18.mif"),
        .biasFile("b_2_18.mif")
    ) n_18 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 18)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[18]),
        .outValid(internal_out_valid[18])
    );

    Node #(
        .Layer_num(2), .Node_num(19), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_19.mif"),
        .biasFile("b_2_19.mif")
    ) n_19 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 19)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[19]),
        .outValid(internal_out_valid[19])
    );

    Node #(
        .Layer_num(2), .Node_num(20), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_20.mif"),
        .biasFile("b_2_20.mif")
    ) n_20 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 20)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[20]),
        .outValid(internal_out_valid[20])
    );

    Node #(
        .Layer_num(2), .Node_num(21), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_21.mif"),
        .biasFile("b_2_21.mif")
    ) n_21 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 21)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[21]),
        .outValid(internal_out_valid[21])
    );

    Node #(
        .Layer_num(2), .Node_num(22), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_22.mif"),
        .biasFile("b_2_22.mif")
    ) n_22 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 22)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[22]),
        .outValid(internal_out_valid[22])
    );

    Node #(
        .Layer_num(2), .Node_num(23), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_23.mif"),
        .biasFile("b_2_23.mif")
    ) n_23 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 23)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[23]),
        .outValid(internal_out_valid[23])
    );

    Node #(
        .Layer_num(2), .Node_num(24), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_24.mif"),
        .biasFile("b_2_24.mif")
    ) n_24 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 24)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[24]),
        .outValid(internal_out_valid[24])
    );

    Node #(
        .Layer_num(2), .Node_num(25), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_25.mif"),
        .biasFile("b_2_25.mif")
    ) n_25 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 25)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[25]),
        .outValid(internal_out_valid[25])
    );

    Node #(
        .Layer_num(2), .Node_num(26), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_26.mif"),
        .biasFile("b_2_26.mif")
    ) n_26 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 26)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[26]),
        .outValid(internal_out_valid[26])
    );

    Node #(
        .Layer_num(2), .Node_num(27), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_27.mif"),
        .biasFile("b_2_27.mif")
    ) n_27 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 27)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[27]),
        .outValid(internal_out_valid[27])
    );

    Node #(
        .Layer_num(2), .Node_num(28), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_28.mif"),
        .biasFile("b_2_28.mif")
    ) n_28 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 28)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[28]),
        .outValid(internal_out_valid[28])
    );

    Node #(
        .Layer_num(2), .Node_num(29), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_29.mif"),
        .biasFile("b_2_29.mif")
    ) n_29 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 29)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[29]),
        .outValid(internal_out_valid[29])
    );

    Node #(
        .Layer_num(2), .Node_num(30), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_30.mif"),
        .biasFile("b_2_30.mif")
    ) n_30 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 30)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[30]),
        .outValid(internal_out_valid[30])
    );

    Node #(
        .Layer_num(2), .Node_num(31), .Weight_num(NUM_INPUTS_LAYER2),
        .weightFile("w_2_31.mif"),
        .biasFile("b_2_31.mif")
    ) n_31 (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == 2) && (config_node_num == 31)),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[31]),
        .outValid(internal_out_valid[31])
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
                shift_count <= 32;
                is_sending <= 1'b1;
                m_axis_tvalid <= 1'b1;
            end 
            else if (is_sending && m_axis_tready && m_axis_tvalid) begin
                if (shift_count == 1) begin
                    is_sending <= 1'b0;
                    m_axis_tvalid <= 1'b0;
                end else begin
                    for (int i = 0; i < 31; i++) begin
                        shift_reg[i] <= shift_reg[i+1];
                    end 
                    shift_count <= shift_count - 1'b1;
                end 
            end 
        end 
    end 

endmodule
