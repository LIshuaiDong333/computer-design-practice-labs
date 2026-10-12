`timescale 1ns / 1ps

module ifetch1(
    input  wire    clk,
    input  wire    rst,   

    input  wire [1:0]  npc_op,
    input  wire [31:0] sext_ext,   //imm
    input  wire [31:0] alu_c,
    
    output wire [31:0] pc,  
    output wire [31:0] npc_pc4
    );
    
    wire [31:0] npc;  

    PC1 U_PC1 (               //4¸ö
        //input
        .clk    (clk),
        .rst  (rst),   
        .din    (npc),
        //output
        .pc     (pc)
    );
    
    NPC U_NPC (                  //6¸ö
        //input
        .npc_op    (npc_op),
        .pc    (pc),
        .imm   (sext_ext),
        .alu_c (alu_c),
        //output
        .npc   (npc),
        .pc4   (npc_pc4)
    );
    
endmodule
