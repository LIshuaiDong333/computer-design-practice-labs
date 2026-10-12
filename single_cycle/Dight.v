`timescale 1ns / 1ps
`include "defines.vh"

module Digit(
    input  wire        clk,
	input  wire        rst,

    input  wire        io_en        ,
    input  wire [31:0] io_addr      ,
    input  wire [31:0] io_write_data,

	output wire [7:0]  dig_en       ,
	output wire        DN_A       ,
	output wire        DN_B       ,
    output wire        DN_C       ,
	output wire        DN_D       ,
	output wire        DN_E       ,
	output wire        DN_F       ,
	output wire        DN_G       ,
	output wire        DN_DP
);

reg [31:0] data;

wire wr = io_en && (io_addr[11:0] == `DIGIT);

always @ (posedge clk or posedge rst) begin
    if (rst) data <= 0;
        else if (wr) data <= io_write_data;
end

Digit_dis U_Digit_dis(
    // input
    .clk    (clk),
    .rst  (rst),

    .data   (data  ), // Êý¾ÝÊäÈë

    // output
    .dig_en (dig_en),
    .DN_A (DN_A),
    .DN_B (DN_B),
    .DN_C (DN_C),
    .DN_D (DN_D),
    .DN_E (DN_E),
    .DN_F (DN_F),
    .DN_G (DN_G),
    .DN_DP (DN_DP)
);

endmodule