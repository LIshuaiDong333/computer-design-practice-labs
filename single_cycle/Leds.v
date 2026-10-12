`timescale 1ns / 1ps
`include "defines.vh"

module Leds(
    input  wire        clk,
	input  wire        rst,

    input  wire        io_en,
    input  wire [31:0] io_addr,
    input  wire [31:0] io_write_data,
	output reg  [23:0] led
);

wire wr = io_en && (io_addr[11:0] == `LED);

always @ (posedge clk or posedge rst) begin
    if (rst) led <= 0;
        else if (wr) led <= io_write_data[23:0];
end

endmodule