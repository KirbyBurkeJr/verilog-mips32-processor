`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Register File
// Module Name: RegFile
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


module RegFile(
    input clk, reset,
	input reg_write_en,
    input [4:0] reg_read_addr_1, reg_read_addr_2, reg_write_addr,
    input [31:0] reg_write_data,

    output [31:0] reg1, reg2 
    );
    
    reg [31:0] reg_array [31:0];  
  
    always @ (negedge clk) begin  
	    if (reset) begin  
			reg_array[0]  <= 32'b0;  
			reg_array[1]  <= 32'b0;  
			reg_array[2]  <= 32'b0;  
			reg_array[3]  <= 32'b0;  
			reg_array[4]  <= 32'b0;  
			reg_array[5]  <= 32'b0;  
			reg_array[6]  <= 32'b0;  
			reg_array[7]  <= 32'b0; 
			reg_array[8]  <= 32'b0;  
			reg_array[9]  <= 32'b0;  
			reg_array[10] <= 32'b0;  
			reg_array[11] <= 32'b0;  
			reg_array[12] <= 32'b0;  
			reg_array[13] <= 32'b0;  
			reg_array[14] <= 32'b0;  
			reg_array[15] <= 32'b0;
			reg_array[16] <= 32'b0;  
			reg_array[17] <= 32'b0; 
			reg_array[18] <= 32'b0;  
			reg_array[19] <= 32'b0;  
			reg_array[20] <= 32'b0; 
			reg_array[21] <= 32'b0;  
			reg_array[22] <= 32'b0;  
			reg_array[23] <= 32'b0;  
			reg_array[24] <= 32'b0;  
			reg_array[25] <= 32'b0;  
			reg_array[26] <= 32'b0;  
			reg_array[27] <= 32'b0; 
			reg_array[28] <= 32'b0;  
			reg_array[29] <= 32'b0;  
			reg_array[30] <= 32'b0;  
			reg_array[31] <= 32'b0;     
        end  
        
		else begin  
			if (reg_write_en) reg_array[reg_write_addr] <= reg_write_data;  
	    end  
    end
	
    assign reg1 = (reg_read_addr_1 == 0)? 32'b0 : reg_array[reg_read_addr_1];  
    assign reg2 = (reg_read_addr_2 == 0)? 32'b0 : reg_array[reg_read_addr_2];  

endmodule
