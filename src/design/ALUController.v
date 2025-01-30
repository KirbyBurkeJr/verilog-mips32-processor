`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Arithmetic Logic Unit (ALU) Controller
// Module Name: ALUController
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


module ALUController(
    input [1:0] alu_op,
    input [5:0] funct,
	
    output reg[3:0] alu_cc
	);
    
	/* Assign selector */
    wire [7:0] ALU_CC_Sel;
    assign ALU_CC_Sel = {alu_op,funct};
    
	always @(ALU_CC_Sel)
        casex (ALU_CC_Sel)
            8'b10100100: alu_cc = 4'b0000; // AND
            8'b11xxxxxx: alu_cc = 4'b0000; // ANDI
            8'b10100101: alu_cc = 4'b0001; // OR
            8'b00xxxxxx: alu_cc = 4'b0010; // ADDI, SW, LW
            8'b10100000: alu_cc = 4'b0010; // ADD
            8'b10100110: alu_cc = 4'b0100; // XOR
            8'b10011000: alu_cc = 4'b0101; // MULT
            8'b10100010: alu_cc = 4'b0110; // SUB
            8'b01xxxxxx: alu_cc = 4'b0110; // BEQ, BNE
            8'b10101010: alu_cc = 4'b0111; // SLT
            8'b10000000: alu_cc = 4'b1000; // SLL
            8'b10000010: alu_cc = 4'b1001; // SRL
            8'b10000011: alu_cc = 4'b1010; // SRA
            8'b10011010: alu_cc = 4'b1011; // DIV
            8'b10100111: alu_cc = 4'b1100; // NOR
            default: alu_cc = 4'b0000; // Fallback: AND
        endcase
endmodule


