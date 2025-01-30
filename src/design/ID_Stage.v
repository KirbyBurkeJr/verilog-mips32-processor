`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Instruction Decode (ID) Pipeline Stage
// Module Name: ID_Stage
// Project Name: Pipelined MIPS32 Processor
// Target Devices: xc7a35ticpg236-1L
// Tool Versions: Vivado v2023.2 (64-bit)
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_Stage(

	/** Input Signals **/
	
    input clk, reset,

	/* Data Hazard Inputs */
    input flush,
	input stall,
	
	/* Instruction Inputs */
    input [31:0] instr,
    input  [9:0] pc_plus4,
	
	/* Register Inputs */
    input reg_write_cc,
    input  [4:0] reg_write_addr,
    input [31:0] reg_write_data,
	

	/** Output Signals **/

	/* Controller Outputs, Hazard-Controlled */
    output [1:0] alu_op,	
    output alu_src, mem_read, mem_to_reg, mem_write, reg_write,

	/* Branch and Jump Outputs */
    output branch_sel, jump_sel,
    output [9:0] branch_addr, jump_addr,
	
	/* Register and Immediate Value Outputs */
    output [31:0] imm_value,
    output [31:0] reg1_out, reg2_out,
    output  [4:0] reg_dest_addr
    );
    
	
	/** Internal Signals **/

	wire Hazard_CC; // Control Hazard Selector

	/* Branch and Jump Control and Address Buses */
	wire Branch_CC;
	wire Jump_CC;
	wire Branch_Sel_bus;
	wire [17:0] Branch_Addr_SLL;
	wire [27:0] Jump_Addr_SLL;

	/* Controller Buses, Hazard-Controlled */
	wire [1:0] ALU_Op_CC;
	wire ALU_Src_CC;
	wire Mem_Read_CC;
	wire Mem_to_Reg_CC;
	wire Mem_Write_CC;
	wire Reg_Write_CC;
	
	wire Reg_Dest_CC_1, Reg_Dest_CC_2;
	wire [4:0] Reg_Dest_Addr;
	
	/* Register and Immediate Value Buses */
	wire [31:0] Imm_Value;
	wire [31:0] Reg1, Reg2;


	/*** Signal Assignments ***/

	assign Hazard_CC = (stall | flush); // Hazard Control Code

	/* Branch Assignments */
	assign Branch_Sel_bus = ( ( ((Reg1 ^ Reg2) == 32'd0) ? 1'b1 : 1'b0) & Branch_CC);
	assign branch_sel = Branch_Sel_bus;
	assign Branch_Addr_SLL = (Imm_Value << 2);
	assign branch_addr = (pc_plus4 + Branch_Addr_SLL[9:0]);

	/* Jump Assignments */
	assign jump_sel = Jump_CC;
	assign Jump_Addr_SLL = (instr[25:0] << 2);
	assign jump_addr = Jump_Addr_SLL[9:0];
	
	/* Register and Immediate Value Assignments */
	assign reg1_out = Reg1;
	assign reg2_out = Reg2;
	assign reg_dest_addr = Reg_Dest_Addr;
	assign imm_value = Imm_Value;


	/*** Submodules and Port Mapping ***/

	Controller Controller_inst(
	
		/* Controller Inputs */
		.reset(reset),
		.opcode(instr[31:26]),

		/* Controller Outputs */
		.alu_op(ALU_Op_CC),
		.alu_src(ALU_Src_CC),
		.mem_read(Mem_Read_CC),
		.mem_to_reg(Mem_to_Reg_CC),
		.mem_write(Mem_Write_CC),
		.reg_write(Reg_Write_CC),

		.branch(Branch_CC),
		.jump(Jump_CC),	
		
		.reg_dest(Reg_Dest_CC_1)
		);

	RegFile RegFile_inst(
		.clk(clk),
		.reset(reset),  
		.reg_read_addr_1(instr[25:21]), // rs
		.reg_read_addr_2(instr[20:16]), // rt
		.reg_write_en(reg_write_cc),
		.reg_write_addr(reg_write_addr),
		.reg_write_data(reg_write_data),
		
		.reg1(Reg1),
		.reg2(Reg2)
		);

	SignExtend SignExtend_inst(
		.sign_ex_in(instr[15:0]),
		.sign_ex_out(Imm_Value)
		);


	/** Controller Output Multiplexers **/

    Mux2_1 #(.mux_width(2)) Mux_ALU_Op (.sel(Hazard_CC), 
		.a(ALU_Op_CC), .b(2'b00), .y(alu_op)
		);
	
    Mux2_1 #(.mux_width(1)) Mux_ALU_Src (.sel(Hazard_CC), 
		.a(ALU_Src_CC), .b(1'b0), .y(alu_src)
		);

    Mux2_1 #(.mux_width(1)) Mux_Mem_Read (.sel(Hazard_CC),
		.a(Mem_Read_CC), .b(1'b0), .y(mem_read)
		);

    Mux2_1 #(.mux_width(1)) Mux_Mem_to_Reg (.sel(Hazard_CC), 
		.a(Mem_to_Reg_CC), .b(1'b0), .y(mem_to_reg) 
		);

    Mux2_1 #(.mux_width(1)) Mux_Mem_Write (.sel(Hazard_CC), 
		.a(Mem_Write_CC), .b(1'b0), .y(mem_write) 
		);

    Mux2_1 #(.mux_width(1)) Mux_Reg_Write (.sel(Hazard_CC), 
		.a(Reg_Write_CC), .b(1'b0), .y(reg_write) 
		);


	/** Destination Register Multiplexers **/
	
    Mux2_1 #(.mux_width(1)) Mux_Reg_Dest_CC (
		.sel(Hazard_CC),
		.a(Reg_Dest_CC_1),
		.b(1'b0),
        
		.y(Reg_Dest_CC_2)
		);
		
    Mux2_1 #(.mux_width(5)) Mux_Reg_Dest_Addr (
        .sel(Reg_Dest_CC_2),
        .a(instr[20:16]),
        .b(instr[15:11]),
        
        .y(Reg_Dest_Addr)
		);
	
endmodule
