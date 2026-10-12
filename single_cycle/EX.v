`timescale 1ns / 1ps
`include "defines.vh"

module EX(
    input  wire        alub_sel,   //B输入二选一信号
    input  wire [2:0]  alu_op,      //运算选择 

    input  wire [31:0] rf_rd1,
    input  wire [31:0] rf_rd2,
    input  wire [31:0] sext_ext,

    output wire [31:0] alu_c,
    output wire        alu_sgn,
    output wire        alu_zero
);

wire [31:0] alu_b;
assign alu_b = alub_sel ? sext_ext : rf_rd2;

ALU U_ALU(
    .op     (alu_op),
    .A      (rf_rd1),
    .B      (alu_b),
    
    .C      (alu_c),
    .sgn    (alu_sgn),
    .zero   (alu_zero)
);

endmodule