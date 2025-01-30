`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  
// Engineer: Kirby Burke
// 
// Create Date: 11/13/2024 10:05:39 PM
// Design Name: MIPS32 Processor Test Bench
// Module Name: tb_MIPS32_Processor
// Project Name: Pipelined MIPS32 Processor Test Bench
// Target Devices: xc7a35ticpg236-1L
// Tool Versions: Vivado v2023.2 (64-bit)
// Description: 
// 
// Dependencies: MIPS32_Processor.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_MIPS32_Processor;
    reg clk;  
    reg reset;  
	
    wire [31:0] result;

    integer point = 0; // Count of successful test cases
	integer f;         // Output CSV variable

	
    MIPS32_Processor uut (  
      .clk(clk),   
      .reset(reset),     
      .result(result)    
    );  
		
    
	/** Initialize CSV file **/
	initial begin	
		f = $fopen("tb_mips32.csv", "w");
		$fwrite(f,"Test Condition,Expected,Actual,Result\n");
	end
	
	/** Close CSV file and finish simulation **/
	initial begin
        #3000; // Delay until all test cases finish
		$fclose(f);
				
        $finish;
	end


    initial begin  
        clk = 0;  
        forever #10 clk = ~clk;  
    end    

    initial begin
        reset = 1;  
		#100;  
		reset = 0;  
		
		/** Load values into first 10 registers **/
		
		uut.Data_Mem.ram[0]= 32'b00000000000000000000000000000001; // 00000001
		uut.Data_Mem.ram[1]= 32'b00001111110101110110111000010000; // 0fd76e10 
		uut.Data_Mem.ram[2]= 32'b01011010000000000100001010011011; // 5a00429b 
		uut.Data_Mem.ram[3]= 32'b00010100001100110011111111111100; // 14333ffc 
		uut.Data_Mem.ram[4]= 32'b00110010000111111110110111001011; // 321fedcb 
		uut.Data_Mem.ram[5]= 32'b10000000000000000000000000000000; // 80000000 
		uut.Data_Mem.ram[6]= 32'b10010000000100101111110101100101; // 9012fd65
		uut.Data_Mem.ram[7]= 32'b10101011110000000000001000110111; // abc00237
		uut.Data_Mem.ram[8]= 32'b10110101010010111100000000110001; // b54bc031
		uut.Data_Mem.ram[9]= 32'b11000001100001111010011000000110; // c187a606 

		$fwrite(f, "Initial Memory Value,00000001,%h,N/A\n", uut.Data_Mem.ram[0]);
		$fwrite(f, "Initial Memory Value,0fd76e10,%h,N/A\n", uut.Data_Mem.ram[1]);
		$fwrite(f, "Initial Memory Value,5a00429b,%h,N/A\n", uut.Data_Mem.ram[2]);
		$fwrite(f, "Initial Memory Value,14333ffc,%h,N/A\n", uut.Data_Mem.ram[3]);
		$fwrite(f, "Initial Memory Value,321fedcb,%h,N/A\n", uut.Data_Mem.ram[4]);
		$fwrite(f, "Initial Memory Value,80000000,%h,N/A\n", uut.Data_Mem.ram[5]);
		$fwrite(f, "Initial Memory Value,9012fd65,%h,N/A\n", uut.Data_Mem.ram[6]);
		$fwrite(f, "Initial Memory Value,abc00237,%h,N/A\n", uut.Data_Mem.ram[7]);
		$fwrite(f, "Initial Memory Value,b54bc031,%h,N/A\n", uut.Data_Mem.ram[8]);
		$fwrite(f, "Initial Memory Value,c187a606,%h,N/A\n", uut.Data_Mem.ram[9]);

		#1500; 

		
		/** Tests with No Hazards **/
		
        $fwrite(f, "No Dependency: ANDI ,0fd76e00,%h,", uut.Data_Mem.ram[11]);
        if(uut.Data_Mem.ram[11]==32'h0fd76e00) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Dependency: NOR,f02891ee,%h,", uut.Data_Mem.ram[12]);
		if(uut.Data_Mem.ram[12]==32'hf02891ee) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Dependency: SLT,00000001,%h,", uut.Data_Mem.ram[13]);
		if(uut.Data_Mem.ram[13]==32'h00000001) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "No Dependency: SLL,7ebb7080,%h,", uut.Data_Mem.ram[14]);
		if(uut.Data_Mem.ram[14]==32'h7ebb7080) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Dependency: SRL,00000000,%h,", uut.Data_Mem.ram[15]);		
		if(uut.Data_Mem.ram[15]==32'h00000000) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "No Dependency: SRA,fe000000,%h,", uut.Data_Mem.ram[16]);
		if(uut.Data_Mem.ram[16]==32'hfe000000) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Dependency: XOR,00000000,%h,", uut.Data_Mem.ram[17]);		
		if(uut.Data_Mem.ram[17]==32'h00000000) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Dependency: MULT ,0fd76e10,%h,", uut.Data_Mem.ram[18]);		
		if(uut.Data_Mem.ram[18]==32'h0fd76e10) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Dependency: DIV,0fd76e10,%h,", uut.Data_Mem.ram[19]);		
		if(uut.Data_Mem.ram[19]==32'h0fd76e10) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
        
		
		/** Data Hazard Tests: Forwarding **/

		$fwrite(f, "No Forwarding: ANDI,00000d61,%h,", uut.Data_Mem.ram[20]);	
		if(uut.Data_Mem.ram[20]==32'h00000d61) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "Forward (B = 2) EX/MEM to EX B: NOR,f028908e,%h,", uut.Data_Mem.ram[21]);	
		if(uut.Data_Mem.ram[21]==32'hf028908e) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "Forward (A = 1) MEM/WB to EX A: SLT,00000001,%h,", uut.Data_Mem.ram[22]);		
		if(uut.Data_Mem.ram[22]==32'h00000001) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");

		$fwrite(f, "No Forwarding: SLL,5faca000,%h,", uut.Data_Mem.ram[23]);	
        if(uut.Data_Mem.ram[23]==32'h5faca000) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "Forward (A = 2) EX/MEM to EX A: SRL,00bf5940,%h,", uut.Data_Mem.ram[24]);
		if(uut.Data_Mem.ram[24]==32'h00bf5940) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "Forward (A = 1) MEM/WB to EX A: SRA,17eb2800,%h,", uut.Data_Mem.ram[25]);
		if(uut.Data_Mem.ram[25]==32'h17eb2800) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "No Forwarding: XOR,9fc59375,%h,", uut.Data_Mem.ram[26]);
		if(uut.Data_Mem.ram[26]==32'h9fc59375) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "No Forwarding: MULT,e4e43c50,%h,", uut.Data_Mem.ram[27]);
		if(uut.Data_Mem.ram[27]==32'he4e43c50) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "Forward (B = 1) MEM/WB to EX B: DIV,00000000,%h,", uut.Data_Mem.ram[28]);
		if(uut.Data_Mem.ram[28]==32'h00000000) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		
		/** Data Hazard Tests: Stalling **/
		
		$fwrite(f, "Data Hazard (RS Dependency): ADD,d15f1416,%h,", uut.Data_Mem.ram[29]);
        if(uut.Data_Mem.ram[29]==32'hd15f1416) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		$fwrite(f, "Data Hazard (RT Dependency): ADD,b54bc032,%h,", uut.Data_Mem.ram[30]);
		if(uut.Data_Mem.ram[30]==32'hb54bc032) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		
		/** Control Hazard Test: Branch **/
		
		$fwrite(f, "Control Hazard: Branch,c187a606,%h,", uut.Data_Mem.ram[31]);
        if(uut.Data_Mem.ram[31]==32'hc187a606) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
		
		
		/** Control Hazard Test: Jump **/
		
		$fwrite(f, "Control Hazard: Jump,b54bc031,%h,", uut.Data_Mem.ram[32]);
		if(uut.Data_Mem.ram[32]==32'hb54bc031) begin
			$fwrite(f, "PASS\n");
			point = point + 1;
		end
		else $fwrite(f, "FAIL\n");
			
		/** Results Summary Message **/
        $display ("Test cases passed: %0d / 22\n", point);
    end
endmodule
