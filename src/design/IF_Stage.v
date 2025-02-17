`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Instruction Fetch (IF) Pipeline Stage
// Module Name: IF_Stage
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


module IF_Stage(
    input clk, reset,
    input stall,
    input branch, jump,
    input [9:0] branch_addr, jump_addr,

    output [31:0] instr,
    output [9:0] pc_plus4
    );
    
	localparam W_PC = 10;
	
	
	/** Internal Buses **/
	
	wire [(W_PC-1):0] Mux_Branch_out, Mux_Jump_out, PC_Plus4;
	reg [9:0] PC_out;
	
	
	/*** Submodules and Port Mapping ***/
	
	/** Branch Selection Mux **/
	Mux2_1 #(.mux_width(W_PC)) MUX2_Branch(
		.sel(branch),
		.a(PC_Plus4),
		.b(branch_addr),
		.y(Mux_Branch_out)
		);	

	/** Jump Selection Mux **/
	Mux2_1 #(.mux_width(W_PC)) MUX2_Jump(
		.sel(jump),
		.a(Mux_Branch_out),
		.b(jump_addr),
		.y(Mux_Jump_out)
		);	
    	
	/** Instruction Memory **/
	InstrMem InstrMem_inst(
		.read_addr(PC_out),
		.data(instr)
		);
    
	/** Program Counter (PC) Module Emulation **/
	always @(posedge clk or posedge reset) begin
	   if (reset) PC_out <= 10'd0;
	   else if (~stall) PC_out <= Mux_Jump_out;
	end
	
	
	/*** Assign Output Signals ***/
	
	assign PC_Plus4 = (PC_out + 10'd4); // Adder
	assign pc_plus4 = PC_Plus4;
	
endmodule
