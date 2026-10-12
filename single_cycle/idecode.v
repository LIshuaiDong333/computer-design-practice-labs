`timescale 1ns / 1ps
`include "defines.vh"

module idecode(
    input  wire        clk,
    input  wire        rst,

    input  wire [2:0]  sext_op,
    
    input  wire [1:0]  rf_wsel,
    input  wire [31:0] alu_c,
    input  wire [31:0] dram_rd,
    input  wire [31:0] npc_pc4,

    input  wire [31:0] irom_inst,  //rR1 rR2 wR
    input  wire        rf_we,    //we 寄存器堆写使能
    
    output wire [31:0] rf_rd1,
    output wire [31:0] rf_rd2,
    output wire [31:0] sext_ext,
    output reg [31:0] rf_wd
    );

    //四选一选择器选写回寄存器数据
    always @(*) begin
        case (rf_wsel)
            `ALU_C   : rf_wd = alu_c;
            `DRAM_RD : rf_wd = dram_rd;
            `NPC_PC4 : rf_wd = npc_pc4;
            `SEXT_EXT: rf_wd = sext_ext;
            default  : rf_wd = alu_c;
        endcase
    end
    
    SEXT U_SEXT(
        //  input
        .op         (sext_op),
        .din        (irom_inst[31:7]),
        //  output
        .ext        (sext_ext)
    );
    
    RF U_RF(
        //  input
        .clk        (clk),
        .rst      (rst),
        .rf_we      (rf_we),
        .rR1        (irom_inst[19:15]),
        .rR2        (irom_inst[24:20]),
        .wR         (irom_inst[11:7]),
        .wD         (rf_wd),
        //  output
        .rD1        (rf_rd1),
        .rD2        (rf_rd2)
    );

endmodule
