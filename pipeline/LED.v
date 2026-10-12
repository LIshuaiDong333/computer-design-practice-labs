`timescale 1ns / 1ps

module LED(
    input wire clk,
    input wire rst,
    input wire we_to_led,
    input wire [31:0]addr_to_led,
    input wire [31:0] wdata_to_led,
    output reg [23:0] device_led
    );

    always@(posedge clk or posedge rst) begin
        if (rst) device_led <= 0;
        else if (we_to_led) device_led <= wdata_to_led[23:0];
    end
endmodule
