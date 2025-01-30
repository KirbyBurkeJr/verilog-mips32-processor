# Pipelined MIPS32 Processor

## Overview

This repository contains the Verilog design and resources for a simplified implementation of a pipelined MIPS32 processor with hazard mitigation, and supporting documentation. For a high-level description of the processor development, visit the [Pipelined MIPS32 Processor](https://kirbyburkejr.com/projects/verilog-mips32-processor) page on my portfolio site.

## Features

### Pipelined Processing

This processor design adheres to the five-stage RISC pipeline, capable of simultaneous instruction processing. This includes hazard mitigation units to explicitly resolve data and control hazards, and the arrangement of its components inherently prevents structural hazards.

### Supported MIPS32 Instructions

The basis of this design is a simplified MIPS implementation, used within a college engineering course. So, some instruction implementations deviate from those in the classic MIPS32 ISA. That said, this processor supports the following instructions.

**R-Type**

- add
- and
- div+
- mult+
- nor
- or
- sll
- slt
- sra
- srl
- sub
- xor

+ Non-standard implementations used for div and mult instructions.

**I-Type**

- addi
- andi
- beq
- bne
- lw
- ori
- sw
- xori

**J-Type**

- j (jump)

## Directories

**docs/**

- mips32_instruction_specifications.png
- mips32_processor_diagram.png

**src/design/**

Contains all the Verilog module designs.

**src/testbench/**

Contains the MIPS32 Processor test bench design.

**sim/**

- tb_MIPS32_Processor_behav.wcfg
- tb_mips.csv

## Instructions

### Cloning the Repository

```bash
git clone https://github.com/kirbyburkejr/verilog-mips32-processor.git
cd verilog-mips32-processor
```

### Running the Simulation

The simulation includes a sequence of 22 test cases to validate the execution of instructions and hazard mitigation responses.

1. Open Vivado and create a new project.
2. Add the files in the `src/design/` and `src/testbench/` directories.
3. Run the simulation using the `tb_MIPS32_Processor.v` test bench file.
 a. Select "Run Simulation" to initiate the simulation.
 b. Select "Run All" to complete the simulation because its duration exceeds the stardand Vivado time limit.

Simulation output includes the display of a performance summary in the Tcl console, saving a detailed performance report to a CSV file (tb_MIPS32.csv), and a waveform diagram.

## Documentation

Detailed block diagram of parent MIP32 Processor module, including submodules, internal bus signals, and port mapping.

Tables with bit allocation for each instruction type.

### Tools Used

- [Vivado v2023.2 (64-bit)](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2023-2.html) for Verilog module design and waveform generation.
- [Lucidchart](https://www.lucidchart.com/pages/) for block diagrams.

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

Feel free to submit issues or pull requests to improve this project.
