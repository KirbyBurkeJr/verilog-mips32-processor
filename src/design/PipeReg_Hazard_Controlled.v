`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Pipeline Register with Hazard Controls
// Module Name: PipeReg_Hazard_Controlled
// Project Name: Pipelined MIPS32 Processor
// Target Devices: xc7a35ticpg236-1L
// Tool Versions: Vivado v2023.2 (64-bit)
// Description:
//   - Pipeline register with the added capabilities to stall and flush
//   - Used for IF/ID registers
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Commdata_hazardts:
// 
//////////////////////////////////////////////////////////////////////////////////


module PipeReg_Hazard_Controlled #(parameter WIDTH=8)(
    input clk, reset,
    input flush, stall,
    input [(WIDTH-1):0] d,
	
    output reg [(WIDTH-1):0] q
    );
    
    always @(posedge clk or posedge reset) begin   
        if (reset) q <= 0; 
        else if (flush) q <= 0;
        else if (~stall) q <= d;  
    end  
endmodule