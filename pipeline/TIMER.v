`timescale 1ns / 1ps
`include "defines.vh"

module TIMER(
    input  wire         clk,
    input  wire         rst,
    input  wire         we,
    input  wire [31:0]  addr,
    input  wire [31:0]  wdata,
    output reg  [31:0]  rdata
);

localparam ADDR_CNT0 = `PERI_ADDR_TIMER;        
localparam ADDR_PR   = `PERI_ADDR_TIMER + 32'h4; 

reg [31:0] cnt0;      
reg [31:0] threshold;  
reg [31:0] cnt1;       

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt0      <= 32'd0;
        threshold <= 32'd0;
        cnt1      <= 32'd0;
    end else begin
        if (we && addr == ADDR_PR) begin
            threshold <= wdata;
        end else if (we && addr == ADDR_CNT0) begin
            cnt0 <= wdata;
        end else begin
            cnt1 <= cnt1 + 1;
            if (cnt1 >= threshold) begin
                cnt1 <= 32'd0;
                cnt0 <= cnt0 + 1;
            end
        end
    end
end

always @(*) begin
    if      (addr == ADDR_CNT0) rdata = cnt0;
    else if (addr == ADDR_PR)   rdata = threshold;
    else                         rdata = 32'd0;
end

endmodule
