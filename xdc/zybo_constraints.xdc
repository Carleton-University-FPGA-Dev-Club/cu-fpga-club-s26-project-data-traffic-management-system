################################################################################
# Carleton University
# Engineers: Leen Naser, Olivia Fullerton
#
# Project: Data Traffic Management System
# Target Device: Digilent Zybo Z7-20
# Tool Version: Vivado 2025.2
#
# Description:
# Physical constraints for the FPGA Traffic Management System hardware
# demonstration on the Digilent Zybo Z7-20.
#
# BTN0:
#   Resets the packet-processing system and LED animation.
#
# LEDs:
#   LD0 - Normal traffic
#   LD1 - Suspicious traffic
#   LD2 - Dropped traffic
#   LD3 - System heartbeat
################################################################################


# ==============================================================================
# 125 MHz SYSTEM CLOCK
# ==============================================================================

set_property PACKAGE_PIN K17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -add -name sys_clk_pin -period 8.000 -waveform {0 4} [get_ports clk]


# ==============================================================================
# BTN0 - RESET
# ==============================================================================

set_property PACKAGE_PIN K18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]


# ==============================================================================
# USER LEDs
# ==============================================================================

# LD0 - Normal Traffic
set_property PACKAGE_PIN M14 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

# LD1 - Suspicious Traffic
set_property PACKAGE_PIN M15 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

# LD2 - Dropped Traffic
set_property PACKAGE_PIN G14 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

# LD3 - System Heartbeat
set_property PACKAGE_PIN D18 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
