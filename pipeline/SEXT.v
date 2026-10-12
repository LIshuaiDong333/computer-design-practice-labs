`timescale 1ns / 1ps
`include "defines.vh"

module SEXT(
    input wire [2:0] op, 
    input wire [24:0] din, //inst[31:7]
    output reg [31:0] ext
    );
wire sgn; 
assign sgn = din[24];
always @(*) begin
    case (op)
    `SEXT_I:ext = {{20{sgn}},din[24:13]};
    `SEXT_S:ext = {{20{sgn}},din[24:18],din[4:0]};
    `SEXT_B:ext = {{20{sgn}},din[0],din[23:18],din[4:1],1'b0};
    `SEXT_J:ext = {{12{sgn}},din[12:5],din[13],din[23:14],1'b0};
    `SEXT_U:ext = {din[24:5],12'b0};
    `SEXT_SHIFT:ext = {{27{sgn}},din[17:13]};
    default:ext = 32'b0;
    endcase
end 
endmodule
