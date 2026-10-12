`timescale 1ns / 1ps

module DISPLAY(
	input wire clk,
	input wire rst,
	input wire [31:0]data,
	
	output reg  [7:0]  led_en,
	output reg         led_ca,
	output reg         led_cb,
	output reg         led_cc,
	output reg         led_cd,
	output reg         led_ce,
	output reg         led_cf,
	output reg         led_cg,
	output wire        led_dp
	);
	assign led_dp = 1;

	reg [17:0] cnt;
	localparam CNT = 18'd199_9; // @100MHz 时钟

	always @(posedge clk or posedge rst) begin
		if (rst) cnt <= 0;
		else if (cnt == CNT) cnt <= 0;
		else cnt <= cnt + 1;
	end

	always @(posedge clk or posedge rst) begin
		if (rst) led_en <= 8'b1111_1110;
		else if (cnt == CNT) led_en <= {led_en[0], led_en[7:1]};
	end

	reg [3:0] hex_digit;

	always @(*) begin
		case (led_en)
			8'b0111_1111: hex_digit = data[31:28];
			8'b1011_1111: hex_digit = data[27:24];
			8'b1101_1111: hex_digit = data[23:20];
			8'b1110_1111: hex_digit = data[19:16];
			8'b1111_0111: hex_digit = data[15:12];
			8'b1111_1011: hex_digit = data[11:8];
			8'b1111_1101: hex_digit = data[7:4];
			8'b1111_1110: hex_digit = data[3:0];
			default:      hex_digit = 4'd0;
		endcase
	end

	always @(*) begin
		case (hex_digit)
		4'h0: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 1;
		end
		4'h1: begin
			led_ca = 1;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 1;
			led_cg = 1;
		end
		4'h2: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 1;
			led_cd = 0;
			led_ce = 0;
			led_cf = 1;
			led_cg = 0;
		end
		4'h3: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 1;
			led_cf = 1;
			led_cg = 0;
		end
		4'h4: begin
			led_ca = 1;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 0;
			led_cg = 0;
		end
		4'h5: begin
			led_ca = 0;
			led_cb = 1;
			led_cc = 0;
			led_cd = 0;
			led_ce = 1;
			led_cf = 0;
			led_cg = 0;
		end
		4'h6: begin
			led_ca = 0;
			led_cb = 1;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'h7: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 1;
			led_cg = 1;
		end
		4'h8: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'h9: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 1;
			led_cf = 0;
			led_cg = 0;
		end
		4'ha: begin
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 1;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'hb: begin
			led_ca = 1;
			led_cb = 1;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'hc: begin
			led_ca = 1;
			led_cb = 1;
			led_cc = 1;
			led_cd = 0;
			led_ce = 0;
			led_cf = 1;
			led_cg = 0;
		end
		4'hd: begin
			led_ca = 1;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 1;
			led_cg = 0;
		end
		4'he: begin
			led_ca = 0;
			led_cb = 1;
			led_cc = 1;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		4'hf: begin
			led_ca = 0;
			led_cb = 1;
			led_cc = 1;
			led_cd = 1;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
		default: begin
			// 全 0 默认为8
			led_ca = 0;
			led_cb = 0;
			led_cc = 0;
			led_cd = 0;
			led_ce = 0;
			led_cf = 0;
			led_cg = 0;
		end
	endcase
end
endmodule
