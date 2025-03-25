module ALU (
    input [3:0] ALUCtl,
    input [2:0] BranchType,
    input [31:0] A,B,
    output reg [31:0] ALUOut,
    output zero,
    output reg final_branch
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not 
    
    // TODO: implement your ALU here
    // Hint: you can use operator to implement
always @(*) begin
    case (ALUCtl)
        4'b0000:  ALUOut = $signed(A) + $signed(B);     //add  (signed)
        4'b0001:  ALUOut = A - B;           //sub
        4'b0010:  ALUOut = A & B;        //and
        4'b0011:  ALUOut = A | B;         //or
        4'b0100:  ALUOut = A ^ B;         //xor
        4'b0101:  ALUOut = ($signed(A) < $signed(B)) ? 1 : 0;      //slt
        4'b0110:  ALUOut = (A < B) ? 1 : 0;         //sltu
        4'b1000:  ALUOut = A << B[4:0];         //sll
        4'b1001:  ALUOut = A >> B[4:0];         //srl
        4'b1010:  ALUOut = A>>>B[4:0];          //sra

        default: ALUOut = 0;
    endcase
    case (BranchType)
        3'b000: final_branch = zero;      //beq
        3'b001: final_branch = !zero;      //bne
        3'b100: final_branch = ($signed(A) < $signed(B)) ? 1 : 0;       //blt
        3'b101: final_branch = ($signed(A) > $signed(B)) ? 1 : 0;       //bgt
        3'b110: final_branch =  (A < B) ? 1 : 0;        //bltu
        3'b111: final_branch = (A > B) ? 1 : 0;         //bgtu
    endcase
end

assign zero = (ALUOut == 0) ? 1'b1 : 1'b0;
    
endmodule

