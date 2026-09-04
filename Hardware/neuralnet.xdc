# 1. 50MHz System Clock (Pin N15)
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports clk]
# create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 10.000} -add [get_ports clk]

# 2. Reset Button (Pin J2)
# NOTE: Renamed to 'rst' to match the NeuralNet_Top.sv and AXI Wrapper definition
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports rst]

# ===================================================================
# 3. 7-SEGMENT DISPLAY (Mapped to DISP0 - Right Display for Digits 0-9)
# ===================================================================

# Anodes [3:0] -> Active Low Digit Select
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports {anode[0]}]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports {anode[1]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {anode[2]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {anode[3]}]

# Cathodes [7:0] -> Active Low Segment Mapping (A-G, DP)
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {cathode[0]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {cathode[1]}]
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {cathode[2]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {cathode[3]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {cathode[4]}]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS33} [get_ports {cathode[5]}]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {cathode[6]}]
set_property -dict {PACKAGE_PIN B5 IOSTANDARD LVCMOS33} [get_ports {cathode[7]}]

# ===================================================================
# 4. USB-UART (For MicroBlaze Communication)
# ===================================================================
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports uart_rtl_0_rxd]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports uart_rtl_0_txd]

set_false_path -from [get_ports rst]
set_false_path -from [get_ports uart_rtl_0_rxd]
set_false_path -to [get_ports {cathode[*] anode[*]}]
set_false_path -to [get_ports uart_rtl_0_txd]