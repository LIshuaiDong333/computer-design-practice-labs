`timescale 1ns / 1ps

module RF(
    input wire     clk,
    input wire      rst,
    input wire      rf_we,   //rf_we 寄存器堆的写使能
    input wire [4:0]    rR1,   
    input wire [4:0]    rR2,
    input wire [4:0]    wR,
    input wire [31:0]    wD,
    
    output wire [31:0]    rD1,
    output wire [31:0]    rD2
);

    reg [31:0]  rf[31:0];
    integer i;

    //根据地址 rR1 和 rR2 直接输出对应寄存器的值
    assign rD1 = rf[rR1];
    assign rD2 = rf[rR2];
    //同步读取
  /*  always @(posedge clk) begin
        rD1 <= (rR1 == 0) ? 0 : rf[rR1];
        rD2 <= (rR2 == 0) ? 0 : rf[rR2];
    end  */
    
    //同步写
    always @(posedge clk or posedge rst) begin
        if(rst)  begin
            for (i = 0; i <= 31; i = i + 1)  begin
                rf[i] <= 32'b0;     //所有寄存器值全部置为全0
            end
        end
        else if (rf_we && (wR != 0)) rf[wR] <= wD;   //写使能且有写地址则写回
        else rf[0] <= 32'b0;    //保持x0为0
    end
    
endmodule
