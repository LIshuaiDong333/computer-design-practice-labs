`timescale 1ns / 1ps
`include "defines.vh"

module ALU(
    input wire[2:0] op,
    input wire[31:0] A,
    input wire[31:0] B,
    output reg[31:0] C,
    output ZF,
    output SF
    );

wire [4:0] shamt = B[4:0];

always @ (*) begin
    case(op)
    `ADD: C = A + B;
    `SUB: C = A - B;
    `AND: C = A & B;
    `OR: C = A | B;
    `XOR: C = A ^ B;
    `SLL: C = A << shamt;
    `SRL: C = A >> shamt;
    `SRA: C = $signed(A) >>> shamt; // 使用算术右移，保留符号位
    default: C = 32'b0;
    endcase

end
assign SF = C[31];
assign ZF = C == 32'b0 ? 1'b1:1'b0;
endmodule