`include "defines.vh"

module ALU (
    input  wire [2:0]  op,
    input  wire [31:0]  A,
    input  wire [31:0]  B,

    output reg  [31:0]  C,
    output wire        sgn,   
    output wire        zero    
);

wire [4:0] shamt = B[4:0];   

always @ (*) begin
    case (op)
        `ADD : C = A + B;
        `AND : C = A & B;
        `OR  : C = A | B;
        `XOR : C = A ^ B;
        `SLL : C = A << shamt;
        `SRL : C = A >> shamt;
        `SRA : C = $signed(A) >>> shamt;
        `SUB : C = A - B;
        default: C = 32'b0;
    endcase
end

assign sgn  = C[31];
assign zero = (C == 32'b0) ? 1'b1 : 1'b0;

endmodule
