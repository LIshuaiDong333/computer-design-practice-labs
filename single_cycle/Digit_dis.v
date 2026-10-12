`timescale 1ns / 1ps

module Digit_dis(
    input  wire        clk,
	input  wire        rst,

    input  wire [31:0] data,

	output reg  [7:0]  dig_en,
	output reg         DN_A,
	output reg         DN_B,
    output reg         DN_C,
	output reg         DN_D,
	output reg         DN_E,
	output reg         DN_F,
	output reg         DN_G,
	output wire        DN_DP
);

assign DN_DP = 1;

reg [10:0] cnt;
localparam CNT_END = 18'd1999;   //设置为 20ns  

always @ (posedge clk or posedge rst) begin
    if(rst) cnt <= 0;     // 复位  变为 0
    	else if (cnt == CNT_END) cnt <= 0;   // 当到达限值时,也变为 0
    	else cnt <= cnt + 1;   // 计数
end

// 使能按照 20ns 的周期变化
always @ (posedge clk or negedge rst) begin
    if (rst) dig_en <= 8'b1111_1110;
        else if (cnt == CNT_END) dig_en <= {dig_en[0], dig_en[7:1]};
end

reg [3:0] hex;   // 一个 16 进制数字

// 分解 data 到每一位上, data 的 4bit 对应 1 个 hex
always @ (*) begin
	case (dig_en)
		8'b0111_1111: hex = data[31:28];
		8'b1011_1111: hex = data[27:24];
		8'b1101_1111: hex = data[23:20];
		8'b1110_1111: hex = data[19:16];
		8'b1111_0111: hex = data[15:12];
		8'b1111_1011: hex = data[11:8 ];
	    8'b1111_1101: hex = data[7 :4 ];
	    8'b1111_1110: hex = data[3 :0 ];
	    default     : hex = 4'h0       ;
	endcase
end

//七段数码管如何表示hex的方法 1
always @ (*) begin
	case (hex)
		4'h0: begin
			// 只有 g 不亮
			DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 0;
			DN_E = 0;
			DN_F = 0;
			DN_G = 1;
		end
		4'h1: begin
			// 只有 b c 亮
            DN_A = 1;
			DN_B = 0;
			DN_C = 0;
			DN_D = 1;
			DN_E = 1;
			DN_F = 1;
			DN_G = 1;
		end
		4'h2: begin
			// 只有 c f 不亮
			DN_A = 0;
			DN_B = 0;
			DN_C = 1;
			DN_D = 0;
			DN_E = 0;
			DN_F = 1;
			DN_G = 0;
		end
		4'h3: begin
			// 只有 e f 不亮
			DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 0;
			DN_E = 1;
			DN_F = 1;
			DN_G = 0;
		end
		4'h4: begin
			DN_A = 1;
			DN_B = 0;
			DN_C = 0;
			DN_D = 1;
			DN_E = 1;
			DN_F = 0;
			DN_G = 0;
		end
		4'h5: begin
			// 只有 b e 不亮
			DN_A = 0;
			DN_B = 1;
			DN_C = 0;
			DN_D = 0;
			DN_E = 1;
			DN_F = 0;
			DN_G = 0;
		end
		4'h6: begin
			// 只有 b 不亮
			DN_A = 0;
			DN_B = 1;
			DN_C = 0;
			DN_D = 0;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
		4'h7: begin
			// 只有 a b c 亮
			DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 1;
			DN_E = 1;
			DN_F = 1;
			DN_G = 1;
		end
		4'h8: begin
			// 全都亮
			DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 0;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
		4'h9: begin
			// 只有 d e 不亮
			DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 1;
			DN_E = 1;
			DN_F = 0;
			DN_G = 0;
		end
		4'ha: begin
		    // 只有 d 不亮
		    DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 1;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
		4'hb: begin
		    // 只有 a b 不亮
		    DN_A = 1;
			DN_B = 1;
			DN_C = 0;
			DN_D = 0;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
		4'hc: begin
		    // 只有 d e g 亮
		    DN_A = 1;
			DN_B = 1;
			DN_C = 1;
			DN_D = 0;
			DN_E = 0;
			DN_F = 1;
			DN_G = 0;
		end
		4'hd: begin
		    // 只有 a f 不亮
		    DN_A = 1;
			DN_B = 0;
			DN_C = 0;
			DN_D = 0;
			DN_E = 0;
			DN_F = 1;
			DN_G = 0;
		end
		4'he: begin
		    // 只有 b c 不亮
		    DN_A = 0;
			DN_B = 1;
			DN_C = 1;
			DN_D = 0;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
		4'hf: begin
		    // 只有 b c d 不亮
		    DN_A = 0;
			DN_B = 1;
			DN_C = 1;
			DN_D = 1;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
		default: begin
			// 默认为 8
			DN_A = 0;
			DN_B = 0;
			DN_C = 0;
			DN_D = 0;
			DN_E = 0;
			DN_F = 0;
			DN_G = 0;
		end
	endcase
end

endmodule