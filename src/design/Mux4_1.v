`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: 4-to-1 Multiplexer
// Module Name: Mux4_1
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


module Mux4_1 #(parameter mux_width=32)(
    input [(mux_width-1):0] a, b, c, d,
    input [1:0] sel,
	
    output [(mux_width-1):0] y
    );
    
    assign y = sel[1] ? (sel[0] ? d : c) : (sel[0] ? b : a);
    
endmodule
