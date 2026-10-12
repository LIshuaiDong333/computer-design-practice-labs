`timescale 1ns / 1ps
`include "defines.vh"
module DETECT_HAZARD(
    input wire clk,
    input wire rst,
    input wire [4:0] rR1_ID,
    input wire [4:0] rR2_ID,
    input wire rf_we_EX,
    input wire [4:0] wR_EX,
    input wire [1:0] rf_wsel_EX,
    input wire [31:0]wD_EX,
    input wire npc_op,
    input wire rf_we_MEM,
    input wire rf_we_WB,
    input wire [31:0]wD_MEM,
    input wire [31:0]wD_WB,
    input wire [4:0]wR_MEM,
    input wire [4:0]wR_WB,
    input wire rD1_flag,
    input wire rD2_flag,
    output wire rD1_op,
    output wire rD2_op,
    output reg [31:0]rD1_forward,
    output reg [31:0]rD2_forward,
    output reg keep_PC,
    output reg keep_IF_ID,
    output reg flush_ID_EX,
    output reg flush_IF_ID,
    output wire load_use_hazard,
    output wire control_hazard

    );
    // 解决数据冒险
    
    wire data_hazard_1_rD1 = (wR_EX == rR1_ID) && rf_we_EX && rD1_flag && wR_EX;                              // wR_EX排除x0，排除load指令
    wire data_hazard_1_rD2 = (wR_EX == rR2_ID) && rf_we_EX && rD2_flag && wR_EX;

    wire data_hazard_2_rD1 = (wR_MEM == rR1_ID) && rf_we_MEM && rD1_flag && wR_MEM;
    wire data_hazard_2_rD2 = (wR_MEM == rR2_ID) && rf_we_MEM && rD2_flag && wR_MEM;

    wire data_hazard_3_rD1 = (wR_WB == rR1_ID) && rf_we_WB && rD1_flag && wR_WB;
    wire data_hazard_3_rD2 = (wR_WB == rR2_ID) && rf_we_WB && rD2_flag && wR_WB;

    assign rD1_op =  data_hazard_1_rD1 || data_hazard_2_rD1 || data_hazard_3_rD1;
    assign rD2_op =  data_hazard_1_rD2 || data_hazard_2_rD2 || data_hazard_3_rD2;

    always@(*) begin
        if (data_hazard_1_rD1) rD1_forward = wD_EX;
        else if (data_hazard_2_rD1) rD1_forward = wD_MEM;
        else if (data_hazard_3_rD1) rD1_forward = wD_WB;
        else rD1_forward = 32'b0;
    end

    always@(*) begin
        if (data_hazard_1_rD2) rD2_forward = wD_EX;
        else if (data_hazard_2_rD2) rD2_forward = wD_MEM;
        else if (data_hazard_3_rD2) rD2_forward = wD_WB;
        else rD2_forward = 32'b0;
    end

    // 加载使用冒险，对于 load 指令，不从 EX 阶段转发数据，因为数据还没从内存读取
    assign load_use_hazard = (data_hazard_1_rD1 || data_hazard_1_rD2) & (rf_wsel_EX == `DRAM);
    
    always @ (*) begin
        if (load_use_hazard) keep_PC = 1'b1;
        else                 keep_PC = 1'b0;
    end

    always @ (*) begin
        if (load_use_hazard) keep_IF_ID = 1'b1;
        else                 keep_IF_ID = 1'b0;
    end

    always @ (*) begin
        if (load_use_hazard||control_hazard) flush_ID_EX = 1'b1;
        else flush_ID_EX = 1'b0;
    end
    
    // 控制冒险
    assign control_hazard = npc_op;

    always @ (*) begin
        if (control_hazard) flush_IF_ID = 1'b1;
        else                flush_IF_ID = 1'b0;
    end

    endmodule

