# FPGA Traffic Management System

A hardware-based packet traffic management system implemented in Verilog for the Digilent Zybo Z7-20 FPGA board.

The project demonstrates an FPGA packet-processing pipeline that generates simulated network traffic, buffers packets through a FIFO queue, inspects packet headers, classifies traffic, applies a suspicious-traffic threshold, and tracks normal, suspicious, and dropped packets in real time.

The completed design was verified through module-level and system-level simulation in Vivado and deployed to physical FPGA hardware with an LED-based traffic visualization.

## Team Members

- **Leen Naser**
- **Olivia Fullerton**

Carleton University FPGA Development Club — Summer 2026

## System Architecture

The system implements the following packet-processing pipeline:

```text
┌──────────────────┐
│ Packet Generator │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│    FIFO Queue    │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Packet Inspector │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Traffic Manager  │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────┐
│ Traffic Statistics       │
│ Normal / Suspicious /    │
│ Dropped Packets          │
└──────────────────────────┘
```

For the physical FPGA demonstration, `board_top.v` connects the packet-processing system to the Zybo Z7-20 LEDs and reset button.

## Modules

### Packet Generator

`packet_generator.v`

Generates a continuous stream of simulated 16-bit network packets.

The generator alternates between:

- Header `0xA` — suspicious traffic
- Header `0xB` — normal traffic

This provides repeatable traffic for testing the rest of the processing pipeline.

### FIFO Queue

`fifo_queue.v`

Implements an 8-entry, 16-bit First-In, First-Out buffer between packet generation and packet inspection.

The FIFO provides:

- Packet buffering
- Read and write control
- Full detection
- Empty detection
- Overflow protection
- Valid-data signalling
- First-in, first-out packet ordering

### Packet Inspector

`packet_inspector.v`

Examines the upper four bits of each packet and classifies the traffic according to predefined rules.

| Packet Header | Classification |
|---|---|
| `0xA` | Suspicious |
| `0xC` | Suspicious |
| `0xF` | Malformed |
| Other values | Normal |

Malformed packets are passed to the traffic manager for immediate dropping.

### Traffic Manager

`traffic_manager.v`

Processes the packet classifications produced by the inspector and maintains three 8-bit counters:

- Normal packets
- Suspicious packets
- Dropped packets

Malformed packets are dropped immediately.

Suspicious packets are accepted until the suspicious packet counter reaches a threshold of **20 packets**. Additional suspicious packets are then counted as dropped traffic.

### Top Module

`top.v`

Integrates the packet generator, FIFO queue, packet inspector, and traffic manager into the complete packet-processing pipeline.

A delayed valid signal synchronizes the registered packet classification output with the traffic manager.

### Hardware Demo Wrapper

`board_top.v`

Provides the top-level interface used for deployment to the Digilent Zybo Z7-20.

Because packet-processing events occur much faster than they can be observed directly, traffic events are latched and represented using human-visible LED animation patterns.

## FPGA Hardware Demonstration

The physical demonstration uses the four user LEDs on the Zybo Z7-20.

| Board I/O | Function |
|---|---|
| **LD0** | Normal traffic activity |
| **LD1** | Suspicious traffic |
| **LD2** | Dropped traffic |
| **LD3** | System heartbeat |
| **BTN0** | System reset |

### LED Patterns

**LD0 — Normal Traffic**

Displays a repeating alternating blink pattern after normal traffic has been detected.

**LD1 — Suspicious Traffic**

Displays a double-flash pattern after suspicious traffic has been detected.

**LD2 — Dropped Traffic**

Displays a triple-flash warning pattern after dropped traffic has been detected.

**LD3 — System Heartbeat**

Blinks approximately every half second to indicate that the FPGA system is actively running.

Holding **BTN0** resets the packet counters, detected-event flags, and LED animation state.

## Verification

The design was tested using both module-level and complete system-level behavioral simulations in Vivado.

### Packet Generator Testbench

`packet_generator_tb.v`

Verifies that the generator:

- Produces valid packets
- Generates suspicious traffic
- Generates normal traffic

### FIFO Queue Testbench

`fifo_queue_tb.v`

Verifies:

- Reset behavior
- Packet writes
- Packet reads
- FIFO ordering
- Full detection
- Empty detection
- Overflow protection
- `data_valid` behavior

### Packet Inspector Testbench

`packet_inspector_tb.v`

Verifies classification of:

- `0xA` headers as suspicious
- `0xC` headers as suspicious
- `0xF` headers as malformed
- `0xB` headers as normal

### Traffic Manager Testbench

`traffic_manager_tb.v`

Verifies:

- Normal packet counting
- Suspicious packet counting
- Immediate malformed-packet dropping
- The 20-packet suspicious traffic threshold
- Dropping of suspicious traffic beyond the threshold

### System-Level Testbench

`top_tb.v`

Verifies operation of the complete integrated pipeline:

```text
Packet Generator
      ↓
FIFO Queue
      ↓
Packet Inspector
      ↓
Traffic Manager
```

The system-level simulation confirms that normal, suspicious, and dropped traffic are all produced and processed by the integrated design.

## Repository Structure

```text
.
├── src/
│   ├── board_top.v
│   ├── fifo_queue.v
│   ├── packet_generator.v
│   ├── packet_inspector.v
│   ├── top.v
│   └── traffic_manager.v
│
├── sim/
│   ├── fifo_queue_tb.v
│   ├── packet_generator_tb.v
│   ├── packet_inspector_tb.v
│   ├── top_tb.v
│   └── traffic_manager_tb.v
│
├── xdc/
│   └── zybo_constraints.xdc
│
└── README.md
```

## Development Tools

- **Verilog HDL**
- **AMD Vivado 2025.2**
- **Digilent Zybo Z7-20**
- **Git**
- **GitHub**

## Running the Project

1. Create or open a Vivado project targeting the **Digilent Zybo Z7-20**.
2. Add the Verilog design files from `src/` as design sources.
3. Add the testbenches from `sim/` as simulation sources.
4. Add `xdc/zybo_constraints.xdc` as the constraints file.
5. Set `top_tb` as the simulation top for complete system simulation.
6. Run Behavioral Simulation to verify the packet-processing pipeline.
7. Set `board_top` as the design top for FPGA deployment.
8. Run Synthesis and Implementation.
9. Generate the bitstream.
10. Connect the Zybo Z7-20 and program the FPGA through Vivado Hardware Manager.

## Key Features

- FPGA-based packet-processing pipeline
- Continuous simulated network traffic generation
- 8-entry FIFO packet buffer
- Header-based packet inspection
- Normal, suspicious, and malformed traffic classification
- Suspicious-traffic threshold enforcement
- Packet drop handling
- Real-time traffic counters
- Module-level verification
- Complete system-level simulation
- Zybo Z7-20 hardware deployment
- Human-visible LED traffic visualization
- Physical reset control

## Project Status

**Completed — Summer 2026**

The complete packet-processing pipeline has been implemented and verified through behavioral simulation. The design has also been synthesized, implemented, programmed, and demonstrated on the Digilent Zybo Z7-20 FPGA board using the onboard LEDs and BTN0 reset control.

## Possible Future Enhancements

Potential extensions to the project include:

- Packet prioritization and multiple traffic classes
- Configurable inspection rules and thresholds
- UART output for traffic statistics
- AXI-Stream interfaces
- External packet input
- More advanced packet-filtering rules
- Hardware-controlled configuration of traffic-management parameters
