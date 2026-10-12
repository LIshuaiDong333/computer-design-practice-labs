`timescale 1ns / 1ps
`include "defines.vh"


module ADD_MUX(
    input wire[31:0] rD2,
    input wire[31:0] ext,
    input wire [1:0]alub_sel,
    output reg[31:0] B
    );
    always@(*)begin
        case(alub_sel)
            `ALUB_EXT:B = ext;
            `ALUB_RS2:B = rD2;
            default:B = rD2;
        endcase
    end
endmodule
