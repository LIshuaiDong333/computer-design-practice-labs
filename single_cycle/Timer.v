`timescale 1ns / 1ps
`include "defines.vh"

module Timer(
    input  wire         clk,
    input  wire         rst,
    input  wire         io_we,
    input  wire [31:0]  io_addr,
    input  wire [31:0]  io_write_data,
    output reg  [31:0]  io_read_data
);

localparam ADDR_CNT0 = {`IO, `TIMER};        // 计数器地址
localparam ADDR_PR   = {`IO, `TIMER} + 32'h4;   // 预分频阈值地址

// 寄存器定义
reg [31:0] cnt0;       // 计数器0
reg [31:0] threshold;  // 预分频阈值
reg [31:0] cnt1;       // 分频计数器

// 时钟驱动逻辑
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt0      <= 32'd0;
        threshold <= 32'd0;
        cnt1      <= 32'd0;
    end else begin
        // 外部写入阈值或初值
        if (io_we && io_addr == ADDR_PR) begin
            threshold <= io_write_data;
        end else if (io_we && io_addr == ADDR_CNT0) begin
            cnt0 <= io_write_data;
        end else begin
            // 常规计数逻辑
            cnt1 <= cnt1 + 1;
            if (cnt1 >= threshold) begin
                cnt1 <= 32'd0;
                cnt0 <= cnt0 + 1;
            end
        end
    end
end

//读数据多路选择
always @(*) begin
    if      (io_addr == ADDR_CNT0) io_read_data = cnt0;
    else if (io_addr == ADDR_PR)   io_read_data = threshold;
    else                         io_read_data = 32'd0;
end

endmodule