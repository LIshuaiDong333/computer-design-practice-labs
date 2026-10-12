`timescale 1ns / 1ps

module SWITCH(
    input wire [31:0] addr_to_sw,
    input wire [23:0] device_sw,
    output wire [31:0] rdata_from_sw
    );

    assign rdata_from_sw = {8'b0,device_sw};
endmodule
