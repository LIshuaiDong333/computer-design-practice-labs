`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,
    output wire [31:0] pc,
    output wire ram_we,
    output wire [31:0] alu_c,
    output wire [31:0] rD2,
    output wire rf_we,
    output wire [31:0] wD,

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
    // use MEM/WB stage signals to reflect write-back data
    assign debug_wb_have_inst = have_inst_WB;                  
    assign debug_wb_pc        = pc_WB;                
    assign debug_wb_ena       = rf_we_WB;              
    assign debug_wb_reg       = wR_WB;                    
    assign debug_wb_value     = wD_WB;             
`endif
   
`ifdef RUN_TRACE
    assign inst_addr = pc[15:2];
`else
    assign inst_addr = pc[13:2];
`endif

wire [2:0] branch_ID, branch_EX;
wire [1:0] jump_ID, jump_EX;

wire rD1_flag, rD2_flag; 
wire rD1_op, rD2_op; 
wire [31:0] rD1_forward, rD2_forward; 
wire keep_PC, keep_IF_ID; 
wire flush_IF_ID, flush_ID_EX;
wire control_hazard,load_use_hazard;

wire npc_op;
wire alub_s ;
wire ram_we_ID, ram_we_EX, ram_we_MEM;
wire ZF;
wire SF;
wire [1:0] rf_wsel_ID,rf_wsel_EX,rf_wsel_MEM;
wire rf_we_ID,rf_we_EX,rf_we_MEM,rf_we_WB;
wire [2:0]  sext_op_ID, sext_op_EX;
wire [3:0]  alu_op_ID, alu_op_EX;

wire [31:0] pc_imm_ID, pc_imm_EX;
wire [31:0] npc;
wire [31:0] npc_change;
wire [31:0] pc_IF, pc_ID, pc_EX, pc_MEM, pc_WB;
wire have_inst_ID, have_inst_EX, have_inst_MEM, have_inst_WB;
wire [31:0] pc4_IF, pc4_ID, pc4_EX,pc4_MEM,pc4_WB;
wire [31:0] inst_IF, inst_ID;
wire [31:0] ext_ID, ext_EX;
wire [31:0] rD1_ID, rD1_EX;
wire [31:0] rD2_ID, rD2_EX, rD2_MEM; 
wire [31:0] alu_b;
wire [31:0] alu_c_EX, alu_c_MEM;
wire [31:0] ram_rd;
wire [31:0] wD_EX, wD_MEM, temp_MEM, wD_WB;
wire [4:0]  wR_ID, wR_EX, wR_MEM, wR_WB;

CONTROLLER U_CONTROLLER(
    .inst(inst_ID),
    .rf_we(rf_we_ID),
    .rf_wsel(rf_wsel_ID),
    .sext_op(sext_op_ID),
    .alu_op(alu_op_ID),
    .alub_sel(alub_sel_ID),
    .ram_we(ram_we_ID),
    .have_inst(have_inst_ID),

    .branch(branch_ID),
    .jump(jump_ID),

    .rD1_flag(rD1_flag),
    .rD2_flag(rD2_flag)
);

PC U_PC(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .keep(keep_PC),
    .din(npc),
    .pc(pc_IF)
);
NPC U_NPC(
    .pc(pc_IF),
    .op(npc_op),
    .npc_change(npc_change),
    .npc(npc),
    .pc4(pc4_IF)
);

assign pc = pc_IF;
assign inst_IF = inst;

IF_ID U_IF_ID(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .control_hazard(control_hazard),
    .load_use_hazard(load_use_hazard),
    
    .keep(keep_IF_ID),

    .pc4_i(pc4_IF),
    .pc4_o(pc4_ID),

    .pc_i(pc_IF),
    .pc_o(pc_ID),

    .inst_i(inst_IF),
    .inst_o(inst_ID)
);


wire [4:0] rR1_ID, rR2_ID, wR_ID;
assign rR1_ID = inst_ID[19:15];
assign rR2_ID = inst_ID[24:20];
assign wR_ID = inst_ID[11:7];
assign pc_imm_ID = pc_ID + ext_ID;

RF U_RF(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .rf_we(rf_we_WB), 
    .rR1(rR1_ID),
    .rR2(rR2_ID),
    .wR(wR_WB),
    .wD(wD_WB),
    .rD1(rD1_ID),
    .rD2(rD2_ID)
);

SEXT U_SEXT(
    .op(sext_op_ID),
    .din(inst_ID[31:7]),
    .ext(ext_ID)
);

DETECT_HAZARD U_DETECT(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .rR1_ID(rR1_ID),
    .rR2_ID(rR2_ID),
    .load_use_hazard(load_use_hazard),
    .control_hazard(control_hazard),
    .rf_wsel_EX(rf_wsel_EX),
    .npc_op(npc_op),
    .rf_we_EX(rf_we_EX),
    .rf_we_MEM(rf_we_MEM),
    .rf_we_WB(rf_we_WB),
    .wD_EX(wD_EX),
    .wD_MEM(wD_MEM),
    .wD_WB(wD_WB),
    .wR_EX(wR_EX),
    .wR_MEM(wR_MEM),
    .wR_WB(wR_WB),
    .rD1_flag(rD1_flag),
    .rD2_flag(rD2_flag),
    .rD1_op(rD1_op),
    .rD2_op(rD2_op),
    .rD1_forward(rD1_forward),
    .rD2_forward(rD2_forward),
    .keep_PC(keep_PC),
    .keep_IF_ID(keep_IF_ID),
    .flush_ID_EX(flush_ID_EX),
    .flush_IF_ID(flush_IF_ID)
);

ID_EX U_ID_EX(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .flush(flush_ID_EX),
    .ram_we_i(ram_we_ID),
    .ram_we_o(ram_we_EX),
    .alu_op_i(alu_op_ID),
    .alu_op_o(alu_op_EX),
    .alub_sel_i(alub_sel_ID),
    .alub_sel_o(alub_sel_EX),
    .jump_i(jump_ID),
    .jump_o(jump_EX),
    .branch_i(branch_ID),
    .branch_o(branch_EX),
    .rf_we_i(rf_we_ID),
    .rf_we_o(rf_we_EX),
    .rf_wsel_i(rf_wsel_ID),
    .rf_wsel_o(rf_wsel_EX),
    .pc_imm_i(pc_imm_ID),
    .pc_imm_o(pc_imm_EX),
    .ext_i(ext_ID),
    .ext_o(ext_EX),
    .rD1_i(rD1_ID),
    .rD1_o(rD1_EX),
    .rD2_i(rD2_ID),
    .rD2_o(rD2_EX),
    .pc4_i(pc4_ID),
    .pc4_o(pc4_EX),
    .pc_i(pc_ID),
    .pc_o(pc_EX),
    .wR_i(wR_ID),
    .wR_o(wR_EX),
    .rD1_op(rD1_op),
    .rD2_op(rD2_op),
    .rD1_forward(rD1_forward),
    .rD2_forward(rD2_forward),
    .have_inst_i(have_inst_ID),
    .have_inst_o(have_inst_EX)
);

// EX stage: operand select, ALU, branch/jump control
ADD_MUX U_ADD_MUX(
    .rD2(rD2_EX),
    .ext(ext_EX),
    .alub_sel(alub_sel_EX),
    .B(alu_b)
);
ALU U_ALU(
    .op(alu_op_EX),
    .A(rD1_EX),
    .B(alu_b),
    .C(alu_c_EX),
    .ZF(ZF),
    .SF(SF)
);
NPC_CONTROL U_NPC_CTRL(
    .branch(branch_EX),
    .jump(jump_EX),
    .ZF(ZF),
    .SF(SF),
    .alu_c(alu_c_EX),
    .pc_imm(pc_imm_EX),
    .npc_op(npc_op),
    .npc_change(npc_change)
);
// EX/MEM pipeline register
EX_MEM U_EX_MEM(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .ram_we_i(ram_we_EX),
    .ram_we_o(ram_we_MEM),
    .rf_we_i(rf_we_EX),
    .rf_we_o(rf_we_MEM),
    .rf_wsel_i(rf_wsel_EX),
    .rf_wsel_o(rf_wsel_MEM),
    .alu_c_i(alu_c_EX),
    .alu_c_o(alu_c_MEM),
    .wD_i(wD_EX), 
    .wD_o(temp_MEM),
    .wR_i(wR_EX),
    .wR_o(wR_MEM),
    .rD2_i(rD2_EX),
    .rD2_o(rD2_MEM),
    .pc_i(pc_EX),
    .pc_o(pc_MEM),
    .have_inst_i (have_inst_EX),
    .have_inst_o (have_inst_MEM),

    .pc4_i(pc4_EX),
    .pc4_o(pc4_MEM)
);
MEM_WB U_MEM_WB(
    .clk(cpu_clk),
    .rst(cpu_rst),
    .rf_we_i(rf_we_MEM),
    .rf_we_o(rf_we_WB),
    .wD_i(wD_MEM),
    .wD_o(wD_WB),
    .wR_i(wR_MEM),
    .wR_o(wR_WB),
    .pc_i(pc_MEM),
    .pc_o(pc_WB),
    .have_inst_i(have_inst_MEM),
    .have_inst_o(have_inst_WB),
    .pc4_i(pc4_MEM),
    .pc4_o(pc4_WB)
);

WD_MUX2 U_WD_MUX2 (
    .rf_wsel      (rf_wsel_MEM   ),
    .rD     (ram_rd      ),
    .temp     (temp_MEM  ),
    .wD          (wD_MEM       )
);
WD_MUX1 U_WD_MUX1 (
    .rf_wsel      (rf_wsel_EX    ),
    .pc4         (pc4_EX       ),
    .ext         (ext_EX       ),
    .alu_c       (alu_c_EX     ),
    .wD          (wD_EX        )
);
assign Bus_addr  = alu_c_MEM;        
assign Bus_we    = ram_we_MEM;       
assign Bus_wdata = rD2_MEM;          
assign ram_rd = Bus_rdata;
endmodule
