`include "alu.svh"
`include "prefix_adder/prefix_adder.sv"
// basic 32-bit ALU
// N - Negative, Z - Zero, C - Carry, V - oVerflow
module alu (
    input [WIDTH - 1:0] a,
    input [WIDTH - 1:0] b,
    input [        1:0] control,

    output logic [WIDTH - 1:0] result,
    output       [        3:0] flags    // N Z C V
);

    localparam WIDTH = 32;
    wire [WIDTH - 1:0] sum;
    wire c_out;

    // ADDER //
    wire [WIDTH - 1:0] b_signed = control[0] ? ~b : b;

    prefix_adder_32 u_prefix_adder_32 (
        .a    (a),
        .b    (b_signed),
        .c_in (control[0]),
        .sum  (sum),
        .c_out(c_out)
    );

    // FLAGS //
    wire oflow = (~ (control[0] ^ a[WIDTH - 1] ^ b[WIDTH - 1])) // sign(a) == sign(b) & control = ADD|SUB
    & (a[WIDTH-1] ^ result[WIDTH-1])  // sign(a) != sign(sum)
    & (~control[1]);  // control == ADD|SUB
    wire carry = c_out & (~control[1]);
    wire zero = &(~result);
    wire neg = result[WIDTH-1];

    assign flags = {neg, zero, carry, oflow};

    // RESULT MUX //
    always_comb begin
        case (control)
            `ALU_ADD: result = sum;
            `ALU_SUB: result = sum;
            `ALU_AND: result = a & b;
            `ALU_OR:  result = a | b;
        endcase
    end

endmodule : alu
