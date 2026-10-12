// Annotate this macro before synthesis
//`define RUN_TRACE
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_TIM   32'hFFFF_F020
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078

//npc_op
`define PC_4           2'b00
`define PC_IMM        2'b01
`define RD1_IMM         2'b10

//rf_we 寄存器堆的写使能
`define DISABLE        1'b0
`define ENABLE         1'b1

//sext_op立即数拼接方式
`define IMM_I          3'b000
`define IMM_SHIFT      3'b001
`define IMM_S          3'b010
`define IMM_B          3'b011
`define IMM_U          3'b100
`define IMM_J          3'b101

//alu_op
`define ADD            3'b000
`define AND            3'b001
`define OR             3'b010
`define XOR            3'b011
`define SLL            3'b100
`define SRL            3'b101
`define SRA            3'b110
`define SUB            3'b111

//ram_we DRAM的写使能
`define READ           1'b0
`define WRITE          1'b1

//rf_wsel
`define ALU_C          2'b00
`define DRAM_RD        2'b01
`define NPC_PC4        2'b10
`define SEXT_EXT       2'b11

//alub_sel
`define ALU_B_RF_RD2   1'b0
`define ALU_B_SEXT_EXT 1'b1

//外设前缀地址
`define IO             20'hfffff
//后12位地址
`define DIGIT          12'h000
`define TIMER          12'h020
`define LED            12'h060
`define SWITCH         12'h070
