`timescale 1ns / 1ps
module RF(
    input wire clk,
    input wire rst,
    input wire rf_we,
    input wire [4:0] rR1,
    input wire [4:0] rR2,
    input wire [4:0] wR,
    input wire [31:0] wD,
    output wire [31:0] rD1,
    output wire [31:0] rD2
    );
reg  [31:0] rf[31:0];
assign rD1 = (rR1 == 5'b0) ? 32'b0 : rf[rR1]; 
assign rD2 = (rR2 == 5'b0) ? 32'b0 : rf[rR2]; 
integer i;
always@ (posedge clk or posedge rst)begin
if (rst)begin
    for (i = 0; i < 32;i = i + 1)begin
        rf[i] <= 32'b0;
        end
    end
        else if (rf_we && (wR != 5'b0))begin
            rf[wR] <= wD;
        end
end
endmodule
