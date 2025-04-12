// сумматор с последовательным переносом
module ripple_carry_adder #(
    parameter WIDTH = 4
) (
    input [WIDTH - 1:0] a,
    input [WIDTH - 1:0] b,
    input               c_in,

    output [WIDTH - 1:0] sum,
    output               c_out
);

    localparam CARRY_CNT = WIDTH + 1;

    wire [CARRY_CNT - 1:0] carry;
    assign carry[0] = c_in;
    assign c_out = carry[CARRY_CNT-1];

    generate
        for (genvar i = 0; i < WIDTH; ++i) begin
            full_adder u_full_adder (
                .a    (a[i]),
                .b    (b[i]),
                .c_in (carry[i]),
                .sum  (sum[i]),
                .c_out(carry[i+1])
            );
        end
    endgenerate

endmodule : ripple_carry_adder
