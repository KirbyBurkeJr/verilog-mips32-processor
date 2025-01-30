`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: Controller
// Module Name: Controller
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


module Controller(
    input reset,
    input [5:0] opcode,

    output reg [1:0] alu_op,
	output reg alu_src, mem_read, mem_to_reg, mem_write, reg_write, 
    output reg branch, jump,
	output reg reg_dest
    );

	always @(*) begin
	
		if(reset == 1'b1) begin  
            alu_op = 2'b00;  
            alu_src = 1'b0;  
            branch = 1'b0; 
            jump = 1'b0;    
            mem_read = 1'b0;  
            mem_to_reg = 1'b0;  
            mem_write = 1'b0;  
            reg_dest = 1'b0;  
            reg_write = 1'b0;  
        end  
		
        else begin  
			casex(opcode)
			
				/* ADD, AND, OR, SUB, NOR, SLT, XOR, MULT, DIV */
				6'b000000: begin
					alu_op = 2'b10;  
					alu_src = 1'b0;  
					branch = 1'b0; 
					jump = 1'b0;    
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b1;  
					reg_write = 1'b1;
                end
                
				/* SLL, SRL, SRA */
				6'b110000: begin
					alu_op = 2'b10;  
					alu_src = 1'b1;  
					branch = 1'b0; 
					jump = 1'b0;    
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b1;  
					reg_write = 1'b1;
                end
                
				/* ADDI */
				6'b001000: begin
					alu_op = 2'b00;  
					alu_src = 1'b1;  
					branch = 1'b0; 
					jump = 1'b0;
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b0;  
					reg_write = 1'b1;    
                end 
      
				/* ANDI */
				6'b001xxx: begin
					alu_op = 2'b11;  
					alu_src = 1'b1;  
					branch = 1'b0; 
					jump = 1'b0;   
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b0;  
					reg_write = 1'b1; 
                end
      
				/* LW */
				6'b100011: begin
					alu_op = 2'b00;    
					alu_src = 1'b1;  
					branch = 1'b0; 
					jump = 1'b0;
					mem_read = 1'b1;  
					mem_to_reg = 1'b1;  
					mem_write = 1'b0;  
					reg_dest = 1'b0;  
					reg_write = 1'b1;   
                end  
   
				/* SW */
				6'b101011: begin
					alu_op = 2'b00;    
					alu_src = 1'b1;  
					branch = 1'b0; 
					jump = 1'b0;
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b1;  
					reg_dest = 1'b0;  
					reg_write = 1'b0;  
                end 
       
				/* BEQ, BNE */
				6'b00010x: begin
					alu_op = 2'b01;  
					alu_src = 1'b0;  
					branch = 1'b1; 
					jump = 1'b0; 
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b0;  
					reg_write = 1'b0;   
                end 
                
				/* JUMP (J) */
				6'b000010: begin
					alu_op = 2'b00;  
					alu_src = 1'b0;  
					branch = 1'b0; 
					jump = 1'b1; 
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b0;  
					reg_write = 1'b0;   
                end 
    
				/* Fallback = JUMP */
				default: begin
					alu_op = 2'b00;  
					alu_src = 1'b0;  
					branch = 1'b0; 
					jump = 1'b1;   
					mem_read = 1'b0;  
					mem_to_reg = 1'b0;  
					mem_write = 1'b0;  
					reg_dest = 1'b0;  
					reg_write = 1'b0; 
                end 	
	
			endcase  
		end  
	end 
endmodule 