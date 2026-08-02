# FPGA Traffic Management System

## Overview

This project implements a simplified FPGA-based packet traffic management system using Verilog on the Digilent Zybo Z7-10 FPGA board.

The system generates network packets, inspects them for suspicious patterns, and tracks traffic statistics in real time. The goal is to demonstrate how FPGA hardware can be used for high-speed packet processing and traffic analysis.

## Team Members

* Leen Naser
* Olivia Fullerton

## Project Architecture

The design consists of four main modules:

### Packet Generator

Generates simulated network packets and marks packets as either normal or suspicious.

### Packet Inspector

Examines packet contents and identifies suspicious packets based on predefined rules.

### Traffic Manager

Processes packet classifications and maintains counters for:

* Normal packets
* Suspicious packets
* Dropped packets

### Top Module

Integrates all modules into a complete packet processing pipeline.

## Current Features

* Packet generation
* Suspicious packet detection
* Traffic classification
* Packet counting
* Packet drop tracking
* Module-level testbenches
* System-level simulation

## Files

### Design Files

* `packet_generator.v`
* `packet_inspector.v`
* `traffic_manager.v`
* `top.v`

### Testbenches

* `packet_generator_tb.v`
* `packet_inspector_tb.v`
* `traffic_manager_tb.v`
* `top_tb.v`

## Development Tools

* Vivado 2025.2
* Verilog HDL
* Digilent Zybo Z7-10 FPGA Board

## Future Improvements

* FIFO packet buffering
* Packet prioritization
* LED-based traffic visualization
* UART statistics output
* Enhanced inspection rules
* Real-time hardware demonstration

## Status

Current status: Functional simulation completed. Hardware deployment and advanced traffic management features are in progress.
