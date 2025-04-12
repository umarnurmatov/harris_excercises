// сумматор с ускоренным переносом
module carry_lookahead_adder #(
    parameter WIDTH = 64
) (
    input [WIDTH - 1:0] a,
    input [WIDTH - 1:0] b,
    input               c_in,

    output [WIDTH - 1:0] sum,
    output               c_out
);

    initial assert (WIDTH / 4 == 0);

    localparam N = WIDTH / 4;
    localparam CARRY_CNT = N + 1;

    wire [CARRY_CNT - 1:0] carry;
    assign carry[0] = c_in;
    assign c_out = carry[CARRY_CNT-1];

    generate
        for (genvar i = 0; i < N; ++i) begin
            carry_lookahead_4 u_carry_lookahead_4 (
                .a    (a[i*4+:4]),
                .b    (b[i*4+:4]),
                .c_in (carry[i]),
                .sum  (sum[i*4+:4]),
                .c_out(carry[i+1])
            );
        end
    endgenerate

endmodule
