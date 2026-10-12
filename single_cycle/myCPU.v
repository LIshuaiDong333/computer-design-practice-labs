`timescale 1ns / 1ps
`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,
    
    //IROM接口
    output  wire [31:0] pc_pc,
    //DROM接口
    output wire        dram_we,
    output wire [31:0] alu_c,
    output wire [31:0] rf_rd2,
    input  wire [31:0] dram_rd,
    //RF使能
    output wire        rf_we,
    inout wire [31:0] rf_wd,
    
    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    `ifdef RUN_TRACE
        assign inst_addr = pc_pc[17:2]; // 按字寻址
    `else
        assign inst_addr = pc_pc[15:2]; // 按字寻址
    `endif
    
    wire [1:0]  npc_op;
    wire [2:0]  sext_op ;
    wire [1:0]  rf_wsel;
    wire        alub_sel;
    wire [2:0]  alu_op;
    wire        alu_sgn;
    wire        alu_zero;
    
    wire [31:0] npc_pc4 ;
    wire [31:0] sext_ext;
    wire [31:0] rf_rd1;
    
    assign Bus_addr  = alu_c;        // Memory address from ALU result
    assign Bus_we    = dram_we;       // Write enable from controller
    assign Bus_wdata = rf_rd2;
    
    CU U_CU(
        .inst       (inst),
        .sgn        (alu_sgn),
        .zero       (alu_zero),
        .npc_op     (npc_op),
        .sext_op    (sext_op),
        .rf_wsel     (rf_wsel),
        .rf_we      (rf_we),
        .alub_sel   (alub_sel),
        .alu_op     (alu_op),
        .ram_we    (dram_we)
    );
    
    ifetch1 U_IF(
        .clk       (cpu_clk      ),
        .rst     (cpu_rst    ),
        .npc_op    (npc_op   ),
        .sext_ext  (sext_ext ),
        .alu_c     (alu_c),
    
        .pc        (pc_pc), 
        .npc_pc4   (npc_pc4)
    );
    
    idecode U_ID(
        .clk       (cpu_clk),
        .rst     (cpu_rst),
        .sext_op   (sext_op),
        .rf_wsel    (rf_wsel),
        .rf_we     (rf_we),
        .irom_inst (inst), 
        .alu_c     (alu_c),
        .dram_rd   (Bus_rdata),     //注意
        .npc_pc4   (npc_pc4), 
        .sext_ext  (sext_ext),
        .rf_rd1    (rf_rd1),
        .rf_rd2    (rf_rd2),
        .rf_wd     (rf_wd)
    );
    
    EX U_EX(
        .alub_sel  (alub_sel ),
        .alu_op    (alu_op   ),
        .rf_rd1    (rf_rd1   ),
        .rf_rd2    (rf_rd2   ),
        .sext_ext  (sext_ext ),
        .alu_c     (alu_c    ),
        .alu_sgn   (alu_sgn  ),
        .alu_zero  (alu_zero )  
    ); 
    
    always @(posedge cpu_clk) begin
    if (rf_we) begin
        $display("[WB] PC=%h, wR=x%d, wD=%h", 
                pc_pc, inst[11:7], rf_wd);
        end
    end
    
    always @(posedge cpu_clk) begin
    $display("INST[%h]: opcode=%b, rd=x%d, rs1=x%d, rs2=x%d", 
            pc_pc, inst[6:0], 
            inst[11:7], inst[19:15], inst[24:20]);
    end
    
    `ifdef RUN_TRACE
        assign debug_wb_have_inst = 1;   //单周期
        assign debug_wb_pc = pc_pc;   //PC.pc 的输出
        assign debug_wb_ena = rf_we;   //即 RF 的写控制信号
        assign debug_wb_reg = inst[11:7]; //目的寄存器
        assign debug_wb_value = rf_wd;   //由ID阶段的RF选择后输出出来的rf_wd
    `endif

endmodule
