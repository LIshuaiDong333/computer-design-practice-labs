`timescale 1ns / 1ps
`include "defines.vh"

module SEXT(
    input  wire [2:0]  op, 
    input  wire [24:0]  din,     //  inst[31:7]

    output  reg  [31:0]  ext    //输出32bit
);

wire sgn = din[24];    //inst[31]一定是符号位,下面直接用来符号位扩展

always @(*)    begin
    case(op)
        `IMM_I:
            ext = {{20{sgn}}, din[24:13]};
        `IMM_SHIFT:
            ext = {27'b0, din[17:13]};    //0扩展
        `IMM_S:      
            ext = {{20{sgn}}, din[24:18], din[4:0]};
        `IMM_B:
            ext = {{19{sgn}}, din[24], din[0], din[23:18], din[4:1], 1'b0};
        `IMM_U:
            ext = {din[24:5], 12'b0};
        `IMM_J:
            ext = {{12{sgn}}, din[12:5], din[13], din[23:14], 1'b0};
        default:
            ext = 32'b0;
    endcase
end

endmodule