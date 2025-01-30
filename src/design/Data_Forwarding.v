`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Data Forwarding Unit
// Module Name: Data_Forwarding
// Project Name: Pipelined MIPS32 Processor
// Target Devices: xc7a35ticpg236-1L
// Tool Versions: Vivado v2023.2 (64-bit)
// Description: Mitigates read after write (RAW) data hazards (non load-use)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_Forwarding(

    input EX_MEM_reg_write_en, MEM_WB_reg_write_en,
    input [4:0] ID_EX_rs_addr, ID_EX_rt_addr, EX_MEM_reg_dest, MEM_WB_reg_dest,
	
    output reg [1:0] forward_A, forward_B
    );
    
    always @(*) begin

		/** Forward A **/
		
        if ((EX_MEM_reg_write_en == 1'b1) & (EX_MEM_reg_dest != 5'd0)
			& (EX_MEM_reg_dest == ID_EX_rs_addr) )
            forward_A = 2'b10;
			
        else if ( (MEM_WB_reg_write_en == 1'b1) & (MEM_WB_reg_dest != 5'd0)
			& ~( (EX_MEM_reg_write_en == 1'b1) & (EX_MEM_reg_dest != 5'd0)
			& (EX_MEM_reg_dest == ID_EX_rs_addr) )
			& (MEM_WB_reg_dest == ID_EX_rs_addr) )
            forward_A = 2'b01;
			
        else forward_A = 2'b00;
        
		
		/** Forward B **/
		
        if ((EX_MEM_reg_write_en == 1'b1) & (EX_MEM_reg_dest != 5'd0)
			& (EX_MEM_reg_dest == ID_EX_rt_addr) )
            forward_B = 2'b10;
		
        else if ( (MEM_WB_reg_write_en == 1'b1) & (MEM_WB_reg_dest != 5'd0)
			& ~( (EX_MEM_reg_write_en == 1'b1) & (EX_MEM_reg_dest != 5'd0)
			& (EX_MEM_reg_dest == ID_EX_rt_addr) )
			& (MEM_WB_reg_dest == ID_EX_rt_addr) )
            forward_B = 2'b01;

        else forward_B = 2'b00;

    end
endmodule
