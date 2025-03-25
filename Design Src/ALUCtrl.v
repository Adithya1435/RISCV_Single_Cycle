module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl,
    output reg [2:0] BranchType
);

    // TODO: implement your ALU ALUCtl here
   // Hint: using ALUOp, funct7, funct3 to select exact operation
always @(*) begin
        case (ALUOp)
            2'b00: ALUCtl = 4'b0000;
            2'b01: begin
                 ALUCtl = 4'b0001;
                 BranchType = funct3;
             end
            2'b10: begin    //R-type
                case (funct3)
                    3'b000: ALUCtl = (funct7) ? 4'b0001 : 4'b0000;
                    3'b001: ALUCtl = 4'b1000;
                    3'b010: ALUCtl = 4'b0101;
                    3'b011: ALUCtl = 4'b0110;
                    3'b100: ALUCtl = 4'b0100;
                    3'b101: ALUCtl = (funct7) ? 4'b1010 : 4'b1001;
                    3'b110: ALUCtl = 4'b0011;
                    3'b111: ALUCtl = 4'b0010;
                    default: ALUCtl = 4'bxxxx;
                endcase
            end
            2'b11: begin  // I-type
                case (funct3)
                    3'b000: ALUCtl = 4'b0000;
                    3'b001: ALUCtl = 4'b1000;
                    3'b010: ALUCtl = 4'b0101;
                    3'b011: ALUCtl = 4'b0110;
                    3'b100: ALUCtl = 4'b0100;
                    3'b101: ALUCtl = (funct7) ? 4'b1010 : 4'b1001;
                    3'b110: ALUCtl = 4'b0011;
                    3'b111: ALUCtl = 4'b0010;
                    default: ALUCtl = 4'bxxxx;
                endcase
            end
            default: ALUCtl = 4'bxxxx;
        endcase
    end

endmodule

