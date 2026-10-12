`timescale 1ns / 1ps
module NPC_CONTROL(
    input wire [2:0] branch,
    input wire [1:0] jump,
    input wire ZF,
    input wire SF,
    input wire [31:0] alu_c,
    input wire [31:0] pc_imm,
    output reg npc_op,
    output reg [31:0] npc_change
    );

    always@(*) begin
        if (jump[0])npc_op = 1'b1;
        else begin
            case(branch)
            3'b001: npc_op = ZF ? 1'b1 : 1'b0;
            3'b011: npc_op = ZF ? 1'b0 : 1'b1;
            3'b101: npc_op = SF ? 1'b1 : 1'b0;
            3'b111: npc_op = SF ? 1'b0 : 1'b1;
            default: npc_op = 1'b0;
            endcase
        end
    end
    
    always@(*) begin
        if (jump == 2'b01) npc_change = {alu_c[31:1],1'b0};
        else npc_change = pc_imm;
    end
endmodule
