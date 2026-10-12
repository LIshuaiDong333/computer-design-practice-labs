`timescale 1ns / 1ps
`include "defines.vh"

module WD_MUX1(
    input wire [31:0] ext,
    input wire [31:0] alu_c,
    input wire [31:0] pc4,
    input wire [1:0] rf_wsel,
    
    output reg[31:0] wD
    );

    always@(*) begin
        case(rf_wsel)
        `WB_ALU : wD = alu_c;
        `WB_EXT : wD = ext;
        `WB_PC4 : wD = pc4;
        default: wD = 32'b0;
        endcase
    end
endmodule
