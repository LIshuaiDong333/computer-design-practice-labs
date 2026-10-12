// Annotate this macro before synthesis
// `define RUN_TRACE

`define NPC_PC4 2'b00
`define NPC_BEQ 2'b01
`define NPC_JMP 2'b10

`define WB_ALU 2'b00
`define WB_EXT 2'b01
`define WB_PC4 2'b10
`define DRAM 2'b11

`define SEXT_I 3'b000
`define SEXT_S 3'b001
`define SEXT_B 3'b010
`define SEXT_J 3'b011
`define SEXT_U 3'b100
`define SEXT_SHIFT 3'b101


`define ALUB_RS2 1'b0
`define ALUB_EXT 1'b1

`define READ 1'b0
`define WRITE 1'b1

`define DISABLE 1'b0
`define ENABLE 1'b1

`define ADD 3'b000
`define AND 3'b001
`define OR 3'b010
`define XOR 3'b011
`define SLL 3'b100
`define SRL 3'b101
`define SRA 3'b110
`define SUB 3'b111

//外设I/O接口电路的端口地址
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
`define PERI_ADDR_TIMER 32'hFFFF_F020
