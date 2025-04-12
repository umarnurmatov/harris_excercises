module carry_lookahead_4 (
    input [3:0] a,
    input [3:0] b,
    input       c_in,

    output [3:0] sum,
    output       c_out
);

    wire [3:0] gen = a & b;  // generate carry
    wire [3:0] prop = a | b;  // propagate carry

    wire overall_gen = gen[3] | (prop[3] & (gen[2] | (prop[2] & (gen[1] | (prop[1] & gen[0])))));
    wire overall_prop = &prop;

    assign c_out = (c_in & overall_prop) | overall_gen;

    ripple_carry_adder #(
        .WIDTH(4)
    ) u_ripple_carry_adder (
        .a   (a),
        .b   (b),
        .c_in(c_in),
        .sum (sum)
    );

endmodule
