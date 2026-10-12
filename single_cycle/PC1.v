`timescale 1ns / 1ps

module PC1(
    input  wire    clk,
    input  wire    rst,
    input  wire [31:0] din,
    output reg  [31:0] pc
    );
    
always @(posedge clk or posedge rst) begin
    if(rst) pc <= -4;
    else pc <= din;
end

endmodule
