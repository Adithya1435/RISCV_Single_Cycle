module SingleCycleCPU (
    input clk,
    input start,
    output [31:0] instr,
    output [31:0] PC,
    output [31:0] PCplus4, 
    output [31:0] PCbranch,
    output [31:0] FinalPC,
    output [31:0] A,
    output [31:0] B, 
    output [31:0] immval, 
    output [31:0] ALUB,
    output branch, 
    output memRead, 
    output memtoReg, 
    output memWrite, 
    output ALUSrc, 
    output regWrite,
    output [1:0] ALUOp,
    output [31:0] ALUOut,
    output [3:0] ALUCtl,
    output zero,
    output [31:0] readData,
    output [31:0] writeData,
    output auipc
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,


//Control Signals
wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite,  jal, final_branch, zero, auipc;
wire [1:0] ALUOp;
wire [2:0] BranchType;
wire [3:0] ALUCtl;

//Datapath wires
wire [31:0] instr;
wire [31:0] PC;
wire [31:0] four = 4;
wire [31:0] PCplus4, PCbranch;
wire [31:0] FinalPC;
wire [31:0] A,B, immval, ALUB;
wire [31:0] readData;
wire [31:0] writeData;
wire [31:0] Data_addr;
wire [31:0] ALUOut;


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(FinalPC),
    .pc_o(PC)
);

Adder m_Adder_1(
    .a(PC),
    .b(four),
    .sum(PCplus4)
);

InstructionMemory m_InstMem(
    .readAddr(PC),
    .inst(instr)
);

Control m_Control(
    .opcode(instr[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .jal(jal),
    .auipc(auipc)
);


Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(instr[19:15]),
    .readReg2(instr[24:20]),
    .writeReg(instr[11:7]),
    .writeData(writeData),
    .readData1(A),
    .readData2(B)
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(instr[31:0]),
    .imm(immval)
);

//ShiftLeftOne m_ShiftLeftOne(
//    .i(),
//    .o()
//);

Adder m_Adder_2(
    .a(PC),
    .b(immval),
    .sum(PCbranch)
);

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel((branch & final_branch) | jal),
    .s0(PCplus4),
    .s1(PCbranch),
    .out(FinalPC)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(B),
    .s1(immval),
    .out(ALUB)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(instr[30]),
    .funct3(instr[14:12]),
    .ALUCtl(ALUCtl),
    .BranchType(BranchType)
);

ALU m_ALU(
    .ALUCtl(ALUCtl),
    .BranchType(BranchType),
    .A(A),
    .B(ALUB),
    .ALUOut(ALUOut),
    .zero(zero),
    .final_branch(final_branch)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(Data_addr),
    .writeData(B),
    .funct3(instr[14:12]),
    .readData(readData)
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(Data_addr),
    .s1(readData),
    .out(writeData)
);

Mux2to1 #(.size(32)) m_Mux_ALUR(
     .sel(auipc),
     .s0(ALUOut),
     .s1(PCbranch),
     .out(Data_addr)
);

endmodule
