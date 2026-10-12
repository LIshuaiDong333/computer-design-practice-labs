`timescale 1ns / 1ps
module EX_MEM(
    input wire clk,
    input wire rst,

    input wire ram_we_i,
    output reg ram_we_o,
    input wire rf_we_i,
    output reg rf_we_o,
    input wire [1:0]rf_wsel_i,
    output reg [1:0]rf_wsel_o,
    input wire [31:0] alu_c_i,
    output reg [31:0] alu_c_o,
    input wire [31:0] wD_i,
    output reg [31:0] wD_o,
    input wire [4:0] wR_i,
    output reg [4:0] wR_o,
    input wire [31:0] rD2_i,
    output reg [31:0] rD2_o,
    input wire [31:0] pc_i,
    output reg [31:0] pc_o,
    input wire [31:0] pc4_i,
    output reg [31:0] pc4_o,
    input  wire have_inst_i,
    output reg have_inst_o
    );

    always@(posedge clk or posedge rst) begin
        if (rst) have_inst_o <= 1'b0;
        else have_inst_o <= have_inst_i;
    end
    always@(posedge clk or posedge rst) begin
        if (rst) ram_we_o <= 1'b0;
        else ram_we_o <= ram_we_i;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) rf_we_o <= 1'b0;
        else rf_we_o <= rf_we_i;
    end    

    always@(posedge clk or posedge rst) begin
        if (rst) wR_o <= 5'b0;
        else wR_o <= wR_i;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) rD2_o <= 32'b0;
        else rD2_o <= rD2_i;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) pc_o <= 32'b0;
        else pc_o <= pc_i;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) pc4_o <= 32'b0;
        else pc4_o <= pc4_i;
    end
    
    always@(posedge clk or posedge rst) begin
        if (rst) rf_wsel_o <= 2'b0;
        else rf_wsel_o <= rf_wsel_i;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) alu_c_o <= 32'b0;
        else alu_c_o <= alu_c_i;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) wD_o <= 32'b0;
        else wD_o <= wD_i;
    end
endmodule
