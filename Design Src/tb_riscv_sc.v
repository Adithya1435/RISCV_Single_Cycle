module tb_riscv_sc;
//cpu testbench

reg clk;
reg start;

wire [31:0] instr;
wire [31:0] PC;
wire [31:0] PCplus4, PCbranch, FinalPC;
wire [31:0] A, B, immval, ALUB;
wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite;
wire [1:0] ALUOp;
wire [31:0] ALUOut;
wire [3:0] ALUCtl;
wire zero;
wire [31:0] readData;
wire [31:0] writeData;
wire auipc;

SingleCycleCPU riscv_DUT(clk, start, instr,
 PC,
 PCplus4, 
 PCbranch,
 FinalPC,
 A,
 B, 
 immval, 
 ALUB,
 branch, 
 memRead, 
 memtoReg, 
 memWrite, 
 ALUSrc, 
 regWrite,
 ALUOp,
 ALUOut,ALUCtl,
 zero,
 readData,
 writeData, auipc);

initial
	forever #5 clk = ~clk;

initial begin
	clk = 0;
	start = 0;
	#10 start = 1;

	#3000 $finish;

end

endmodule