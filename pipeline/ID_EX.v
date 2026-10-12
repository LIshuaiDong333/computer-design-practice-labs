`timescale 1ns / 1ps

module ID_EX(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire ram_we_i,

    output reg ram_we_o,
    input wire [2:0]alu_op_i,
    output reg [2:0]alu_op_o,
    input wire [1:0] jump_i,
    output reg [1:0] jump_o,
    input wire [2:0] branch_i,
    output reg [2:0] branch_o,

    input wire rf_we_i,
    output reg rf_we_o,
    input wire alub_sel_i,
    output reg alub_sel_o,
    input wire [1:0] rf_wsel_i,
    output reg [1:0] rf_wsel_o,
    input wire [31:0] pc_imm_i,
    output reg [31:0] pc_imm_o,

    input wire [31:0] ext_i,
    output reg [31:0] ext_o,
    input wire [31:0] rD1_i,
    output reg [31:0] rD1_o,
    input wire [31:0] rD2_i,
    output reg [31:0] rD2_o,
    input wire [31:0] pc4_i,
    output reg [31:0] pc4_o,

    input wire [31:0] pc_i,
    output reg [31:0] pc_o,
    input wire [4:0]wR_i,
    output reg [4:0] wR_o,
    input wire rD1_op,
    input wire rD2_op,
    input wire [31:0] rD1_forward,
    input wire [31:0] rD2_forward,
    input  wire have_inst_i,
    output reg have_inst_o
);
always@(posedge clk or posedge rst) begin
    if (rst) ram_we_o <= 1'b0;
    else if (flush) ram_we_o <= 1'b0;
    else ram_we_o <= ram_we_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) have_inst_o <= 1'b0;
    else if (flush) have_inst_o <= 1'b0;
    else have_inst_o <= have_inst_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) alu_op_o <= 3'b0;
    else if (flush) alu_op_o <= 3'b0;
    else alu_op_o <= alu_op_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) alub_sel_o <= 1'b0;
    else if (flush) alub_sel_o <= 1'b0;
    else alub_sel_o <= alub_sel_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) jump_o <= 2'b0;
    else if (flush) jump_o <= 2'b0;
    else jump_o <= jump_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) branch_o <= 3'b0;
    else if (flush) branch_o <= 3'b0;
    else branch_o <= branch_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) rf_we_o <= 1'b0;
    else if (flush) rf_we_o <= 1'b0;
    else rf_we_o <= rf_we_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) rf_wsel_o <= 2'b0;
    else if (flush) rf_wsel_o <= 2'b0;
    else rf_wsel_o <= rf_wsel_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) pc_imm_o <= 32'b0;
    else if (flush) pc_imm_o <= 32'b0;
    else pc_imm_o <= pc_imm_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) ext_o <= 32'b0;
    else if (flush) ext_o <= 32'b0;
    else ext_o <= ext_i;
end


always@(posedge clk or posedge rst) begin
    if (rst) rD1_o <= 32'b0;
    else if (rD1_op) rD1_o <= rD1_forward;
    else rD1_o <= rD1_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) rD2_o <= 32'b0;
    else if (rD2_op) rD2_o <= rD2_forward;
    else rD2_o <= rD2_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) pc4_o <= 32'b0;
    else if (flush) pc4_o <= 32'b0;
    else pc4_o <= pc4_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) pc_o <= 32'b0;
    else if (flush) pc_o <= 32'b0;
    else pc_o <= pc_i;
end

always@(posedge clk or posedge rst) begin
    if (rst) wR_o <= 5'b0;
    else if (flush) wR_o <= 5'b0;
    else wR_o <= wR_i;
end
endmodule
