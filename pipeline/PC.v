module PC(
    input wire clk,
    input wire rst,
    input wire keep,
    input wire [31:0] din,
    output reg [31:0] pc
    );  
    always@(posedge clk or posedge rst)begin
        if (rst) pc <= -4;
        else if (keep) pc <= pc;
        else pc <= din;
    end
endmodule
