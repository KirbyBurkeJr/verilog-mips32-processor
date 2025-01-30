`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Execution (EX) Pipeline Stage
// Module Name: EX_Stage
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


module EX_Stage(
	
	/** Input Signals **/
	
	/* ALU Controller Selectors */
	input [1:0] alu_op_cc,
	input [5:0] funct_cc,
	
	/* MUX Selectors */
	input alu_src,
	input [1:0] forward_A, forward_B,

	/* MUX Unique Inputs */
	input [31:0] imm_value, // MUX2:1 input b
	input [31:0] reg1,      // MUX_Fwd_A input a
	input [31:0] reg2,      // MUX_Fwd_B input a
	
	/* MUX 4:1 Shared Inputs */
	input [31:0] WB_result,     // input b
	input [31:0] alu_result_in, // input c
	
	
	/** Output Signals **/
	
    output [31:0] mem_write_data, // MUX2:1 output
    output [31:0] alu_result_out  // ALU output
    );


	/** Parameters and Internal Signals **/
	
	localparam W_INSTR = 32;
	
	wire [3:0] ALU_CC; // ALUController to ALU
	wire [(W_INSTR-1):0] ALU_A_in; // Mux_Fwd_A_out
	wire [(W_INSTR-1):0] ALU_B_in; // MUX2:1 out
	wire [(W_INSTR-1):0] Mux_Fwd_B_out;
	
	
    /** Submodules and Port Mapping **/

	ALU ALU_inst (
		.alu_sel(ALU_CC),
		.a(ALU_A_in),
		.b(ALU_B_in),
		
		.alu_result(alu_result_out)
		//.zero() // Not used
		);

	ALUController ALUController_inst(
		.alu_op(alu_op_cc), 
		.funct(funct_cc),
	
		.alu_cc(ALU_CC)
		);
	
	Mux4_1 #(.mux_width(W_INSTR)) Mux_Fwd_A(
		.sel(forward_A),
		.a(reg1),
		.b(WB_result),
		.c(alu_result_in),
		.d(32'd0),
		
		.y(ALU_A_in)
		);
	
	Mux4_1 #(.mux_width(W_INSTR)) Mux_Fwd_B(
		.sel(forward_B),
		.a(reg2),
		.b(WB_result),
		.c(alu_result_in),
		.d(32'd0),
		
		.y(Mux_Fwd_B_out)
		);
		
    Mux2_1 #(.mux_width(W_INSTR)) Mux_ALU_B (
		.sel(alu_src),
		.a(Mux_Fwd_B_out),       
        .b(imm_value),

		.y(ALU_B_in)
		);

    /** Signal Assignments **/
	
    assign mem_write_data = Mux_Fwd_B_out;

endmodule
