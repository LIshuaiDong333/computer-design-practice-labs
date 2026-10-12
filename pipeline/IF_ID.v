`timescale 1ns / 1ps

module IF_ID(
    input wire clk,
    input wire rst,
    input wire keep,
    input wire control_hazard,
    input wire load_use_hazard,
    input wire [31:0] pc_i,
    input wire [31:0] inst_i,
    input wire [31:0] pc4_i,

    output reg [31:0] pc4_o,
    output reg [31:0] pc_o,
    output reg [31:0] inst_o

    );

    always@(posedge clk or posedge rst)begin
        if (rst) pc4_o <= 32'b0;
        else if (control_hazard) pc4_o <= 32'b0;
        else if (load_use_hazard) pc4_o <= pc4_o;
        else  pc4_o <= pc4_i;
    end

    always@(posedge clk or posedge rst)begin
        if (rst) pc_o <= 32'b0;
        else if (control_hazard) pc_o <= 32'b0;
        else if (load_use_hazard) pc_o <= pc_o;
        else  pc_o <= pc_i;
    end

    always@(posedge clk or posedge rst)begin
        if (rst) inst_o <= 32'b0;
        else if (control_hazard) inst_o <= 32'b0;
        else if (load_use_hazard) inst_o <= inst_o;
        else  inst_o <= inst_i;
    end
endmodule
