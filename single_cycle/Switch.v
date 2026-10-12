`include "defines.vh"

module Switch(
    //input  wire        io_en,
    input  wire [31:0] io_addr,
    input  wire [23:0] device_sw,
	output wire [31:0] io_read_data
);

//wire wr = io_en && (io_addr[11:0] == `SWITCH);
assign io_read_data = {8'b0, device_sw};

endmodule