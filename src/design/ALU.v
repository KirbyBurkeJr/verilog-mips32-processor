`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Arithmetic Logic Unit (ALU)
// Module Name: ALU
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


module ALU(
    input [31:0] a, b,
    input  [3:0] alu_sel,
	
    output zero, 
    output reg [31:0] alu_result
	); 
    
    wire signed [31:0] Signed_a; 
    
    assign Signed_a = a;
    
	always @(*) begin   
		case(alu_sel)  
			4'b0000: alu_result = a & b; // AND  
			4'b0001: alu_result = a | b; // OR  
			4'b0010: alu_result = a + b; // ADD
			4'b0100: alu_result = a ^ b; // XOR
			4'b0101: alu_result = a * b; // MULT   
			4'b0110: alu_result = a - b; // SUB
			
			4'b0111: alu_result = (a < b) ? 32'd1 : 32'd0; // SLT
			4'b1000: alu_result = a << b[10:6];            // SLL 
			4'b1001: alu_result = a >> b[10:6];            // SRL			
			4'b1010: alu_result = Signed_a >>> b[10:6];    // SRA 
			
			4'b1011: alu_result = a / b;    // DIV 
			4'b1100: alu_result = ~(a | b); // NOR  
			default: alu_result = a + b;    // ADD  
		endcase  
	end  

	assign zero = (alu_result==32'd0) ? 1'b1: 1'b0;

endmodule
