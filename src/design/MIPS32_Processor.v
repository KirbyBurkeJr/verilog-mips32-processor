`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: 32-Bit MIPS Processor
// Module Name: MIPS32_Processor
// Project Name: Pipelined MIPS32 Processor
// Target Devices: xc7a35ticpg236-1L
// Tool Versions: Vivado v2023.2 (64-bit)
// Description: Parent container for MIPS32 processor design
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPS32_Processor(
    input clk, reset,  
    output [31:0] result
    );
    
    /* Parameters */
    localparam W_ALU_OP = 2;
    localparam W_INSTR = 32;
    localparam W_PC = 10;
    localparam W_REG = 5;


	/*** Internal Signals ***/
	
	/* Branch, Jump, and Hazard Control Signals */
    wire Branch_Sel, Jump_Sel; // Branch and Jump Control Signals
    wire Flush, Stall;         // Hazard Detection Signals
    wire [1:0] Fwd_A, Fwd_B;   // EX Forwarding Signals


	/** Stage and Register Signals **/

    /* IF Stage Signals */
    wire [W_INSTR-1:0] IF_Instr;
    wire [W_PC-1:0] IF_PC_Plus4;

    /* IF/ID Register Signals */
    wire [W_INSTR-1:0] IF_ID_Instr;
    wire [W_PC-1:0] IF_ID_PC_Plus4;

    /* ID Stage Signals */
    wire [W_ALU_OP-1:0] ID_ALU_Op, ID_EX_ALU_Op;
    wire ID_ALU_Src, ID_EX_ALU_Src;
    wire [W_REG-1:0] ID_Reg_Dest_Addr, ID_EX_Reg_Dest_Addr;
    wire [W_INSTR-1:0] ID_Imm_Value, ID_EX_Imm_Value;
    wire ID_Mem_Read, ID_EX_Mem_Read;
    wire ID_Mem_to_Reg, ID_EX_Mem_to_Reg;
    wire ID_Mem_Write, ID_EX_Mem_Write;
    wire ID_Reg_Write, ID_EX_Reg_Write;
    wire [W_INSTR-1:0] ID_Reg1, ID_EX_Reg1;
    wire [W_INSTR-1:0] ID_Reg2, ID_EX_Reg2;
    wire [W_PC-1:0] Branch_Addr, Jump_Addr;

    /* EX Stage Signals */
    wire [W_INSTR-1:0] EX_Mem_Write_Data, EX_MEM_Mem_Write_Data;
    wire [W_INSTR-1:0] EX_ALU_Result, EX_MEM_ALU_Result;
    wire [W_REG-1:0] EX_MEM_Reg_Dest_Addr;
    wire [W_INSTR-1:0] ID_EX_Instr;
    wire EX_MEM_Mem_Read, EX_MEM_Mem_to_Reg, EX_MEM_Mem_Write, EX_MEM_Reg_Write;

    /* MEM Stage Signals */
    wire [W_INSTR-1:0] MEM_Mem_Read_Data, MEM_WB_Mem_Read_Data;
    wire [W_INSTR-1:0] MEM_WB_ALU_Result;
    wire [W_REG-1:0] MEM_WB_Reg_Dest;
    wire MEM_WB_Mem_to_Reg, MEM_WB_Reg_Write;

    /* WB Stage Signal */
    wire [W_INSTR-1:0] WB_Result;


	/*** Submodules and Port Mapping ***/

    /** IF Stage **/
    IF_Stage IF_Stage_inst (
        .clk(clk),
        .reset(reset),
        .stall(Stall),
        .branch(Branch_Sel),
        .branch_address(Branch_Addr),
        .jump(Jump_Sel),
        .jump_address(Jump_Addr),
		
        .instr(IF_Instr),
        .pc_plus4(IF_PC_Plus4)
    );

    /** IF/ID Registers **/
    PipeReg_Hazard_Controlled #(.WIDTH(W_INSTR)) IF_ID_Reg_0(.clk(clk), .reset(reset),
		.stall(Stall), .flush(Flush),
        .d(IF_Instr), .q(IF_ID_Instr)
    );
    PipeReg_Hazard_Controlled #(.WIDTH(W_PC)) IF_ID_Reg_1(.clk(clk), .reset(reset),
		.stall(Stall), .flush(Flush),
        .d(IF_PC_Plus4), .q(IF_ID_PC_Plus4)
    );

    /** ID Stage **/
    ID_Stage ID_Stage_inst(
	
        /* ID Inputs */
        .clk(clk),
        .reset(reset),
        .reg_write_cc(MEM_WB_Reg_Write),

        .flush(Flush),
        .stall(Stall),
		
        .instr(IF_ID_Instr),
        .pc_plus4(IF_ID_PC_Plus4),
        .reg_write_addr(MEM_WB_Reg_Dest),
        .reg_write_data(WB_Result),
        
		/* ID Outputs */
        .alu_op(ID_ALU_Op),
        .alu_src(ID_ALU_Src),
        .mem_read(ID_Mem_Read),
        .mem_to_reg(ID_Mem_to_Reg),
        .mem_write(ID_Mem_Write),
        .reg_write(ID_Reg_Write),

        .branch_sel(Branch_Sel),
		.branch_addr(Branch_Addr),
        .jump_sel(Jump_Sel),
        .jump_addr(Jump_Addr),
		
        .imm_value(ID_Imm_Value),
        .reg1_out(ID_Reg1),
        .reg2_out(ID_Reg2),
        .reg_dest_addr(ID_Reg_Dest_Addr)
    );
	

    /** ID/EX Registers **/
    PipeReg #(.WIDTH(W_ALU_OP)) ID_EX_Reg_0(.clk(clk), .reset(reset),
        .d(ID_ALU_Op), .q(ID_EX_ALU_Op)
    );
    PipeReg #(.WIDTH(1)) ID_EX_Reg_1(.clk(clk), .reset(reset),
        .d(ID_ALU_Src), .q(ID_EX_ALU_Src)
    );
    PipeReg #(.WIDTH(W_INSTR)) ID_EX_Reg_2(.clk(clk), .reset(reset),
        .d(ID_Imm_Value), .q(ID_EX_Imm_Value)
    );
    PipeReg #(.WIDTH(1)) ID_EX_Reg_3(.clk(clk), .reset(reset),
        .d(ID_Mem_Read), .q(ID_EX_Mem_Read)
    );
    PipeReg #(.WIDTH(1)) ID_EX_Reg_4(.clk(clk), .reset(reset),
        .d(ID_Mem_to_Reg), .q(ID_EX_Mem_to_Reg)
    );
    PipeReg #(.WIDTH(1)) ID_EX_Reg_5(.clk(clk), .reset(reset),
        .d(ID_Mem_Write), .q(ID_EX_Mem_Write)
    );
    PipeReg #(.WIDTH(W_REG)) ID_EX_Reg_6(.clk(clk), .reset(reset),
        .d(ID_Reg_Dest_Addr), .q(ID_EX_Reg_Dest_Addr)
    );
    PipeReg #(.WIDTH(1)) ID_EX_Reg_7(.clk(clk), .reset(reset),
        .d(ID_Reg_Write), .q(ID_EX_Reg_Write)
    );
    PipeReg #(.WIDTH(W_INSTR)) ID_EX_Reg_8(.clk(clk), .reset(reset),
        .d(ID_Reg1), .q(ID_EX_Reg1)
    );
    PipeReg #(.WIDTH(W_INSTR)) ID_EX_Reg_9(.clk(clk), .reset(reset),
        .d(ID_Reg2), .q(ID_EX_Reg2)
    );
    PipeReg #(.WIDTH(W_INSTR)) ID_EX_Reg_10(.clk(clk), .reset(reset),
        .d(IF_ID_Instr), .q(ID_EX_Instr)
    );


    /** EX Stage **/
    EX_Stage EX_Stage_inst(
	
		/* EX Inputs */
        .alu_op_cc(ID_EX_ALU_Op),
        .funct_cc(ID_EX_Instr[5:0]),
		
        .alu_src(ID_EX_ALU_Src),
        .forward_A(Fwd_A),
        .forward_B(Fwd_B),

        .imm_value(ID_EX_Imm_Value),
        .reg1(ID_EX_Reg1),
        .reg2(ID_EX_Reg2),

        .WB_result(WB_Result),		
        .alu_result_in(EX_MEM_ALU_Result),

		/* EX Outputs */
        .mem_write_data(EX_Mem_Write_Data),
        .alu_result_out(EX_ALU_Result)
    );
	

    /** EX/MEM Registers **/
    PipeReg #(.WIDTH(W_INSTR)) EX_MEM_Reg0(.clk(clk), .reset(reset),
        .d(EX_ALU_Result), .q(EX_MEM_ALU_Result)
    );
    PipeReg #(.WIDTH(W_INSTR)) EX_MEM_Reg1(.clk(clk), .reset(reset),
        .d(EX_Mem_Write_Data), .q(EX_MEM_Mem_Write_Data)
    );
    PipeReg #(.WIDTH(1)) EX_MEM_Reg2(.clk(clk), .reset(reset),
        .d(ID_EX_Mem_Read), .q(EX_MEM_Mem_Read)
    );
    PipeReg #(.WIDTH(1)) EX_MEM_Reg3(.clk(clk), .reset(reset),
        .d(ID_EX_Mem_to_Reg), .q(EX_MEM_Mem_to_Reg)
    );
    PipeReg #(.WIDTH(1)) EX_MEM_Reg4(.clk(clk), .reset(reset),
        .d(ID_EX_Mem_Write), .q(EX_MEM_Mem_Write)
    );
    PipeReg #(.WIDTH(W_REG)) EX_MEM_Reg5(.clk(clk), .reset(reset),
        .d(ID_EX_Reg_Dest_Addr), .q(EX_MEM_Reg_Dest_Addr)
    );
    PipeReg #(.WIDTH(1)) EX_MEM_Reg6(.clk(clk), .reset(reset),
        .d(ID_EX_Reg_Write), .q(EX_MEM_Reg_Write)
    );


    /** MEM Stage **/
    DataMem Data_Mem(
        .clk(clk),
		.mem_read_en(EX_MEM_Mem_Read),
        .mem_write_en(EX_MEM_Mem_Write),
        .mem_addr(EX_MEM_ALU_Result),
        .mem_write_data(EX_MEM_Mem_Write_Data),

        .mem_read_data(MEM_Mem_Read_Data)
    );


    /** MEM/WB Registers **/
	PipeReg #(.WIDTH(W_INSTR)) MEM_WB_Reg0(.clk(clk), .reset(reset),
        .d(MEM_Mem_Read_Data), .q(MEM_WB_Mem_Read_Data)
    );
    PipeReg #(.WIDTH(W_INSTR)) MEM_WB_Reg1(.clk(clk), .reset(reset),
        .d(EX_MEM_ALU_Result), .q(MEM_WB_ALU_Result)
    );
    PipeReg #(.WIDTH(1)) MEM_WB_Reg2(.clk(clk), .reset(reset),
        .d(EX_MEM_Mem_to_Reg), .q(MEM_WB_Mem_to_Reg)
    );
    PipeReg #(.WIDTH(W_REG)) MEM_WB_Reg3(.clk(clk), .reset(reset),
        .d(EX_MEM_Reg_Dest_Addr), .q(MEM_WB_Reg_Dest)
    );
    PipeReg #(.WIDTH(1)) MEM_WB_Reg4(.clk(clk), .reset(reset),
        .d(EX_MEM_Reg_Write), .q(MEM_WB_Reg_Write)
    );


    /** WB Stage **/
    Mux2_1 #( .mux_width(W_INSTR)) Mux_WB(
        .sel(MEM_WB_Mem_to_Reg),
        .a(MEM_WB_ALU_Result),
        .b(MEM_WB_Mem_Read_Data),
		
        .y(WB_Result)
    );


    /** Data Forwarding Unit **/
    Data_Forwarding Data_Forwarding_inst(
	
		/* Data Forwarding Inputs */
		.EX_MEM_reg_write_en(EX_MEM_Reg_Write),
        .MEM_WB_reg_write_en(MEM_WB_Reg_Write),

        .ID_EX_rs_addr(ID_EX_Instr[25:21]),
        .ID_EX_rt_addr(ID_EX_Instr[20:16]),
        .EX_MEM_reg_dest(EX_MEM_Reg_Dest_Addr),
        .MEM_WB_reg_dest(MEM_WB_Reg_Dest),

		/* Data Forwarding Outputs */
        .forward_A(Fwd_A),
        .forward_B(Fwd_B)
    );


    /** Hazard Detection Unit **/
    Hazard_Detection Hazard_Detection_inst(
	    
		/* Hazard Detection Inputs */
		.branch_sel(Branch_Sel),
        .jump_sel(Jump_Sel),
        .ID_EX_mem_read_en(ID_EX_Mem_Read),
		
        .IF_ID_rs(IF_ID_Instr[25:21]),
        .IF_ID_rt(IF_ID_Instr[20:16]),
        .ID_EX_reg_dest(ID_EX_Reg_Dest_Addr),

		/* Hazard Detection Outputs */
        .stall(Stall),
        .flush(Flush)
    );	


	/*** MIPS32_Processor Output Assignment ***/
    assign result = WB_Result;

endmodule
