`timescale 1ns / 1ps

`include "defines.vh"
module WD_MUX2(
    input wire [31:0] temp,
    input wire [31:0] rD,
    input wire [1:0] rf_wsel,
    output reg [31:0] wD
    );
    always@(*) begin
        if (rf_wsel == `DRAM) begin
            wD = rD;
        end
        else begin
            wD = temp;
        end
    end

endmodule
