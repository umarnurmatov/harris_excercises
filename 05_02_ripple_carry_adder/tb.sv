module tb;
    localparam WIDTH = 32;

    logic               clk;
    logic [WIDTH - 1:0] a;
    logic [WIDTH - 1:0] b;
    logic               c_in;
    logic [WIDTH - 1:0] sum;
    logic               c_out;

    ripple_carry_adder #(.WIDTH(WIDTH)) dut (.*);

    initial begin
        clk = '0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpvars();

        c_in = '0;

        repeat (1000) begin
            @(posedge clk);

            a = $urandom();
            b = $urandom();

            #1;

            if (a + b !== sum) begin
                $display("ERROR a: %h, b: %h, actual sum: %h, intended sum: %h", a, b, sum, a + b);
                $finish();
            end
        end
        $display("%s PASS", `__FILE__);
        $finish();
    end

endmodule
