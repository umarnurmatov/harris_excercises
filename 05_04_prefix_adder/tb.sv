module tb;
    localparam WIDTH = 16;

    logic               clk;
    logic [    WIDTH:0] a_ext;
    logic [    WIDTH:0] b_ext;
    logic               c_in;
    logic [WIDTH - 1:0] sum;
    logic [    WIDTH:0] sum_ext;
    logic               c_out;

    prefix_adder_16 u_prefix_adder_16 (
        .a    (a_ext[WIDTH-1:0]),
        .b    (b_ext[WIDTH-1:0]),
        .c_in (c_in),
        .sum  (sum),
        .c_out(c_out)
    );

    initial begin
        clk = '0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpvars();

        c_in = '0;

        repeat (1000) begin
            @(posedge clk);

            a_ext[WIDTH] = '0;
            b_ext[WIDTH] = '0;
            a_ext[WIDTH-1:0] = $urandom();
            b_ext[WIDTH-1:0] = $urandom();

            #1;

            sum_ext = a_ext + b_ext;
            if (sum_ext !== {c_out, sum}) begin
                $display(
                    "ERROR a: %h, b: %h, actual sum: %h, expected sum: %h, actual overflow: %b, expected overflow: %b",
                    a_ext[WIDTH-1:0], b_ext[WIDTH-1:0], sum, sum_ext[WIDTH-1:0], c_out,
                    sum_ext[WIDTH]);
                $finish();
            end
        end
        $display("%s PASS", `__FILE__);
        $finish();
    end

endmodule

