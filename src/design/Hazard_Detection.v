`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Hazard Detection
// Module Name: Hazard_Detection
// Project Name: Pipelined MIPS32 Processor
// Target Devices: xc7a35ticpg236-1L
// Tool Versions: Vivado v2023.2 (64-bit)
// Description: 
//   - Mitigates load-use read after write (RAW) data hazards
//   - Mitigates control hazards 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hazard_Detection(

    input branch_sel, jump_sel, ID_EX_mem_read_en,
    input [4:0] IF_ID_rs_addr, IF_ID_rt_addr, ID_EX_reg_dest,

    output reg flush, stall
    );
    
    always @(*) begin
        
        /** Load-Use Read after Write (RAW) Data Hazard **/
        
        if ( (ID_EX_mem_read_en == 1'b1) &
            ( (ID_EX_reg_dest == IF_ID_rs_addr) | (ID_EX_reg_dest == IF_ID_rt_addr) ) )
            stall = 1'b1;
        
        else stall = 1'b0;
	
	
	/** Control Hazard **/
        
        flush = (branch_sel | jump_sel);
	
    end
endmodule
