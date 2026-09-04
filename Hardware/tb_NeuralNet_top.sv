`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2026 11:41:41 AM
// Design Name: 
// Module Name: tb_NeuralNet_Top.sv
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


module tb_NeuralNet_Top();

    // ==========================================
    // 1. PARAMETERS & SIGNAL DECLARATIONS
    // ==========================================
    localparam int DATA_WIDTH = 16;
    localparam int NUM_PIXELS = 784;

    logic clk;
    logic rst;
    
    // AXI-Lite Configuration Interface (Tied to 0 for pre-trained ROM test)
    logic [31:0] config_layer_num = '0;
    logic [31:0] config_node_num  = '0;
    logic [31:0] config_addr      = '0;
    logic [DATA_WIDTH-1:0] config_data = '0;
    logic config_en      = 1'b0;
    logic config_is_bias = 1'b0;
    
    // AXI-Stream Input (From MicroBlaze/DMA)
    logic [DATA_WIDTH-1:0] s_axis_tdata;
    logic s_axis_tvalid;
    logic s_axis_tready;
    
    // AXI-Stream Output (To MicroBlaze/DMA)
    logic [DATA_WIDTH-1:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready;
    logic m_axis_tlast;
    
    // Physical Urbana Board Outputs
    logic [3:0] anode;
    logic [7:0] cathode;

    // ==========================================
    // 2. DEVICE UNDER TEST (DUT)
    // ==========================================
    NeuralNet_Top dut (
        .clk(clk),
        .rst(rst),
        
        .config_layer_num(config_layer_num),
        .config_node_num(config_node_num),
        .config_addr(config_addr),
        .config_data(config_data),
        .config_en(config_en),
        .config_is_bias(config_is_bias),
        
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast),
        
        .anode(anode),
        .cathode(cathode)
    );

    // ==========================================
    // 3. CLOCK GENERATION (100 MHz)
    // ==========================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // ==========================================
    // 4. MAIN TEST SEQUENCE
    // ==========================================
    initial begin
        // Initialize Signals
        rst = 1'b1;
        s_axis_tdata  = '0;
        s_axis_tvalid = 1'b0;
        
        // The DMA is always ready to catch the final 1-word answer
        m_axis_tready = 1'b1; 

        // Apply Reset (Active-High based on previous fixes)
        #50;
        rst = 1'b0;
        #50;

        $display("--------------------------------------------------");
        $display("[%0t] Starting Full Neural Network Pipeline Test", $time);
        $display("--------------------------------------------------");

        // Stream the 784-pixel image into Layer 1
        s_axis_tvalid = 1'b1;
        for (int i = 0; i < NUM_PIXELS; i++) begin
            
            // In a real verification scenario, you would read an MNIST image array here.
            // For structural pipeline testing, sending a counter is sufficient.
            s_axis_tdata = DATA_WIDTH'(i); 

            @(posedge clk);
            
            // Crucial: Respect backpressure if Layer 1 is busy shifting out data
            while (!s_axis_tready) begin
                @(posedge clk);
            end
        end
        
        s_axis_tvalid = 1'b0;
        $display("[%0t] Image Transfer Complete. Deep Pipeline Computing...", $time);

       // ==========================================
        // 5. WAIT FOR DEEP PIPELINE CASCADING
        // ==========================================
        // Layer 1 -> Layer 2 -> Layer 3 -> Layer 4 -> findMaxDigit
        
        // Wait until the exact clock edge the output is valid
        while (!m_axis_tvalid) begin
            @(posedge clk);
        end

        // ==========================================
        // 6. VERIFY OUTPUTS
        // ==========================================
        $display("==================================================");
        $display("                 CLASSIFICATION COMPLETE          ");
        $display("==================================================");
        
        // 1. Observe AXI signals IMMEDIATELY while the pulse is high
        $display("[%0t] Final Winning Digit Index : %0d", $time, m_axis_tdata);
        if (m_axis_tlast) begin
            $display("[%0t] tlast correctly asserted by findMaxDigit.", $time);
        end else begin
            $error("[%0t] Missing tlast assertion on final output!", $time);
        end

        // 2. Wait one clock cycle for the display_AXI_Wrapper flip-flops to latch
        @(posedge clk); 
        
        // 3. Observe the delayed physical hardware signals
        $write("[%0t] 7-Segment Physical Output : Anode = %b, Cathode = %b -> Displaying Digit: ", $time, anode, cathode);
        
        case (cathode)
            8'b1100_0000: $display("0"); 
            8'b1111_1001: $display("1"); 
            8'b1010_0100: $display("2"); 
            8'b1011_0000: $display("3"); 
            8'b1001_1001: $display("4"); 
            8'b1001_0010: $display("5"); 
            8'b1000_0010: $display("6"); 
            8'b1111_1000: $display("7"); 
            8'b1000_0000: $display("8"); 
            8'b1001_0000: $display("9"); 
            default:      $display("OFF/INVALID");
        endcase
        $display("==================================================");

        #100;
        $display("[%0t] --- SIMULATION SUCCESS ---", $time);
        $finish;
    end 
endmodule