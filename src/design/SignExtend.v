`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Sign Extend
// Module Name: SignExtend
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


module SignExtend(
    input [15:0] sign_ex_in,
	
    output reg [31:0] sign_ex_out
    );
    
    always @(*) begin
        sign_ex_out = { {16{sign_ex_in[15]}}, sign_ex_in[15:0] };
    end
endmodule
