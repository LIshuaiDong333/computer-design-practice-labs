`timescale 1ns / 1ps
`include "defines.vh"
module CONTROLLER #(
    localparam R = 7'b0110011,
    localparam I = 7'b0010011,
    localparam S = 7'b0100011,
    localparam B = 7'b1100011,
    localparam LOAD = 7'b0000011,
    localparam LUI = 7'b0110111,
    localparam JAL = 7'b1101111,
    localparam JALR = 7'b1100111

)(
    input wire [31:0] inst,
    output reg rf_we,
    output reg [1:0] rf_wsel,
    output reg [2:0] sext_op,
    output reg [2:0] alu_op,
    output reg alub_sel,
    output reg ram_we,
    output wire [2:0]  branch,
    output wire [1:0]  jump,
    output wire rD1_flag,
    output wire rD2_flag,
    output reg have_inst
);

wire [6:0] opcode = inst[6:0];
wire [2:0] func3 = inst[14:12];
wire [6:0] func7 = inst[31:25];

assign branch = {func3[2], func3[0], (opcode == B)};
assign jump = {opcode[3], (opcode == JALR) || (opcode == JAL)}; 

assign rD1_flag = ~((opcode == LUI) || (opcode == JAL));
assign rD2_flag = ((opcode == R) || (opcode == S) || (opcode == B));

always @ (*) begin
    case (opcode)
        R, I, LOAD, S, B, LUI, JAL, JALR:
            have_inst = 1'b1;
        default:
            have_inst = 1'b0;
    endcase
end
// Conplete the function of rf_we
always @(*) begin
    case(opcode)
        R, I, LOAD, LUI, JAL, JALR: rf_we = `ENABLE;
        S, B: rf_we = `DISABLE;
        default: rf_we = `DISABLE;  // 无效指令不写回
    endcase
end

// Complete the function of rf_wsel
always @(*) begin
    case(opcode)
    I, R:begin
        rf_wsel = `WB_ALU;
    end
    LUI:begin
        rf_wsel = `WB_EXT;
    end
    LOAD:begin
        rf_wsel = `DRAM;
    end
    JAL,JALR:begin
        rf_wsel = `WB_PC4;
    end
    default:
        rf_wsel = `WB_ALU;
    endcase
end

// Complete the function of sext_op
always @ (*) begin
    case(opcode)
    I:begin
        case(func3)
        3'b000:begin
            sext_op = `SEXT_I;
        end
        3'b111:begin
            sext_op = `SEXT_I;
        end
        3'b110:begin
            sext_op = `SEXT_I;
        end
        3'b100:begin
            sext_op = `SEXT_I;
        end
        3'b001,3'b101:begin
            sext_op = `SEXT_SHIFT;
        end
        default:sext_op = `SEXT_I;
        endcase
    end
    LUI:begin
        sext_op = `SEXT_U;
    end
    LOAD,JALR:begin
        sext_op = `SEXT_I;
    end
    B:begin
        sext_op = `SEXT_B;
    end
    S:begin
        sext_op = `SEXT_S;
    end
    JAL:begin
        sext_op = `SEXT_J;
    end
    default:
        sext_op = `SEXT_I;
    endcase
end
// Complete the function of alu_op
always@(*) begin
    case(opcode)
    R:begin
        case(func3)
            3'b000:begin
                alu_op = func7[5] ? `SUB : `ADD;
            end
            3'b111:begin
                alu_op = `AND;
            end
            3'b110:begin
                alu_op = `OR;
            end
            3'b100:begin
                alu_op = `XOR;
            end
            3'b001:begin
                alu_op = `SLL;
            end
            3'b101:begin
                alu_op = func7[5] ? `SRA : `SRL;
            end
            default:alu_op =`ADD;
        endcase
    end
    I:begin
        case(func3)
        3'b000:
        begin
            alu_op = `ADD;
        end
        3'b111:
        begin
            alu_op = `AND;
        end
        3'b110:
        begin
            alu_op = `OR;
        end
        3'b100:
        begin
            alu_op = `XOR;
        end
        3'b001:begin
            alu_op = `SLL;
        end
        3'b101:begin
            alu_op = func7[5] ? `SRA : `SRL;
        end
        default:alu_op = `ADD;
        endcase
    end
    LOAD,S,JALR:begin
        alu_op = `ADD;
    end
    B:begin
        alu_op = `SUB;
    end
    default:alu_op = `ADD;
    endcase
end
// Complete the function of alub_sel
always@(*) begin
    case(opcode)
    I,LOAD,S,JALR:
    alub_sel = `ALUB_EXT;
    default:
    alub_sel = `ALUB_RS2;
    endcase
end
// Complete the function of ram_we
always@(*)begin
    if(opcode == S)begin
        ram_we = `WRITE;
    end
    else ram_we = `READ;
end
endmodule