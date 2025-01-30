# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-30

### Added

#### General

- [**LICENSE**](LICENSE)
- [**README.md**](README.md)

#### Design Modules (src/design/)

- **ALU.v**: Arithmetic Logic Unit (ALU)
- **ALUController.v**: ALU Controller
- **Controller.v**: Controller
- **Data_Forwarding.v**: Data Forwarding Unit
- **DataMem.v**: Data Memory
- **EX_Stage.v**: Execution (EX) Stage container
- **Hazard_Detection.v**: Hazard Detection Unit
- **ID_Stage.v**: Instruction Decode (ID) Stage container
- **IF_Stage.v**: Instruction Fetch (IF) Stage container
- **InstrMem.v**: Instruction Memory
- **MIPS32_Processor.v**: MIPS32 Processor (parent container)
- **Mux2_1.v**: 2:1 Multiplexer
- **Mux4_1.v**: 4:1 Multiplexer
- **PipeReg.v**: Pipeline Register
- **PipeReg_Hazard_Controlled.v**: Pipeline Register with Hazard Controls
- **RegFile.v**: Register File
- **SignExtend.v**: Sign Extend


#### Test Bench (src/testbench/)

- **tb_MIPS32_Processor.v**: MIPS32 Processor Test Bench

#### Documentation (doc/)

- **mips32_processor_diagram.png**: Block diagram for MIPS32 Processor parent container and submodules
- **mips32_instruction_specifications.png**: Tables for instruction formatting

#### Simulation Output (sim/)

- **tb_MIPS32_Processor_behav.wcfg**: Waveform output from Vivado simulation
- **tb_mips.csv**: Example of simulation CSV output file
