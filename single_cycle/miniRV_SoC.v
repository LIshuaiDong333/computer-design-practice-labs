`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,

    input  wire [23:0]  sw,    //24位拨码开关
    input  wire [ 4:0]  button,    //按键开关1111
    output wire [ 7:0]  dig_en,   //7段数码管
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led    //24位LED灯

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, 
    output wire [31:0]  debug_wb_pc,       
    output              debug_wb_ena,       
    output wire [ 4:0]  debug_wb_reg,     
    output wire [31:0]  debug_wb_value     
`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;
    
//self-add
    wire [31:0] pc_pc;
    wire        dram_we;
    wire        rf_we;
    wire [31:0] dram_rd;
    wire [31:0] alu_c;
    wire [31:0] rf_rd2;
    wire [31:0] rf_wd;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [13:0] inst_addr;
`endif

    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_we;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         we_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
`ifdef RUN_TRACE
    assign cpu_clk = fpga_clk;
`else
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),
        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),
        .pc_pc     (pc_pc), // output
        .dram_we   (dram_we), // output
        .alu_c     (alu_c), // output
        .rf_rd2    (rf_rd2), // output
        .dram_rd   (dram_rd), // input
        .rf_we     (rf_we), // output
        .rf_wd     (rf_wd),  // output
        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_we             (Bus_we),
        .Bus_wdata          (Bus_wdata)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    wire dig_rst;
    wire dig_clk;
    wire [31:0] dig_addr;
    wire dig_we;
    wire [31:0] dig_write_data;
    
    wire led_rst;
    wire led_clk;
    wire [31:0] led_addr;
    wire led_we;
    wire [31:0] led_write_data;
    
    wire sw_rst;
    wire sw_clk;
    wire [31:0] sw_addr;
    wire [31:0] sw_read_data;
    
    wire timer_rst;
    wire timer_clk;
    wire [31:0] timer_addr;
    wire timer_we;
    wire [31:0] timer_write_data;
    wire [31:0] timer_read_data;
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .we_from_cpu        (Bus_we),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .we_to_dram         (we_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (dig_rst),
        .clk_to_dig         (dig_clk),
        .addr_to_dig        (dig_addr),
        .we_to_dig          (dig_we),
        .wdata_to_dig       (dig_write_data),

        // Interface to LEDs
        .rst_to_led         (led_rst),
        .clk_to_led         (led_clk),
        .addr_to_led        (led_addr),
        .we_to_led          (led_we),
        .wdata_to_led       (led_write_data),

        // Interface to switches
        .rst_to_sw          (sw_rst),
        .clk_to_sw          (sw_clk),
        .addr_to_sw         (sw_addr),
        .rdata_from_sw      (sw_read_data),

        // Interface to buttons
        .rst_to_timer       (timer_rst),
        .clk_to_timer       (timer_clk),
        .addr_to_timer      (timer_addr),
        .we_to_timer        (timer_we),
        .wdata_to_timer     (timer_write_data),
        .rdata_from_timer   (timer_read_data)
    );
    
    Timer U_Timer(
        .clk(timer_clk),
        .rst(timer_rst),
        .io_we(timer_we),
        .io_addr(timer_addr),
        .io_write_data(timer_write_data),
        .io_read_data(timer_read_data)
    );

    Digit U_Digit(
        .clk            (dig_clk),
        .rst          (dig_rst),
        .io_en          (dig_we),
        .io_addr        (dig_addr),
        .io_write_data  (dig_write_data),
        .dig_en         (dig_en),
        .DN_A         (DN_A),
        .DN_B         (DN_B),
        .DN_C         (DN_C),
        .DN_D         (DN_D),
        .DN_E         (DN_E),
        .DN_F         (DN_F),
        .DN_G         (DN_G),
        .DN_DP         (DN_DP)
    );
    
    Switch U_Switch(
        .io_addr        (sw_addr),
        .device_sw      (sw),
        .io_read_data   (sw_read_data)
    );

    Leds U_Leds(
        .clk            (led_clk),
        .rst          (led_rst),
        .io_en          (led_we),
        .io_addr        (led_addr),
        .io_write_data  (led_write_data),
        .led     (led)
    );

    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (addr_bridge2dram[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (we_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
    always @(posedge cpu_clk) begin
    $display("IROM[%h] -> %h (PC=%h)", inst_addr, inst, pc_pc);
    end

    // TODO:

endmodule
