layer_num = 4
node_num = 10
data_width = 16

sv_code = f"""module Layer_{layer_num} import nn_definitions_pkg::*; (
    input logic clk,
    input logic rst,

    input logic config_en,
    input logic config_is_bias,
    input logic config_layer_num,
    input logic config_node_num,
    input logic [$clog2(NUM_INPUTS_LAYER{layer_num})-1:0] config_addr,
    input logic [{data_width}-1:0] config_data,

    input logic s_axis_tvalid,
    output logic s_axis_tready,
    input logic [{data_width}-1:0] s_axis_tdata,

    output logic m_axis_tvalid,
    input logic m_axis_tready,
    output logic [{data_width}-1:0] m_axis_tdata,
    output logic m_axis_tlast
);

logic [{node_num}-1:0][{data_width}-1:0] internal_data_out;
logic [{node_num}-1:0] internal_out_valid;
logic is_sending;

logic [{node_num}-1:0][{data_width}-1:0] shift_reg;
logic [$clog2({node_num}):0] shift_count;

assign s_axis_tready = 1'b1;

assign m_axis_tdata = shift_reg[0];
assign m_axis_tlast = (shift_count == 1) && m_axis_tvalid;
"""
for i in range(node_num):
    sv_code += f"""
    Node #(
        .Layer_num({layer_num}), .Node_num({i}), .Weight_num(NUM_INPUTS_LAYER{layer_num}),
        .weightFile("w_{layer_num}_{i}.mif"),
        .biasFile("b_{layer_num}_{i}.mif")
    ) n_{i} (
        .clk(clk), .rst(rst),
        .config_en(config_en && (config_layer_num == {layer_num}) && (config_node_num == {i})),
        .config_is_bias(config_is_bias),
        .config_addr(config_addr),
        .config_data(config_data),
        .givenInput(s_axis_tdata),
        .givenInputValid(s_axis_tvalid && s_axis_tready),
        .out(internal_data_out[{i}]),
        .outValid(internal_out_valid[{i}])
    );
"""

sv_code += f"""

    always_ff @(posedge clk) begin
        if (rst) begin
            is_sending <= 1'b0;
            m_axis_tvalid <= 1'b0;
            shift_count <= '0;
        end 
        else begin
            if (internal_out_valid[0] && !is_sending) begin
                shift_reg <= internal_data_out;
                shift_count <= {node_num};
                is_sending <= 1'b1;
                m_axis_tvalid <= 1'b1;
            end 
            else if (is_sending && m_axis_tready && m_axis_tvalid) begin
                if (shift_count == 1) begin
                    is_sending <= 1'b0;
                    m_axis_tvalid <= 1'b0;
                end else begin
                    for (int i = 0; i < {node_num - 1}; i++) begin
                        shift_reg[i] <= shift_reg[i+1];
                    end 
                    shift_count <= shift_count - 1'b1;
                end 
            end 
        end 
    end 

endmodule
"""
with open(f"Layer_{layer_num}.sv", "w") as f:
    f.write(sv_code)
print(f"Successfully generated Layer_{layer_num}.sv")