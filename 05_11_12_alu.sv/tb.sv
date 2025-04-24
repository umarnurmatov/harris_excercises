`include "alu.svh"

`define ANSI_COLOR_RED "\x1b[31m"
`define ANSI_COLOR_GREEN "\x1b[32m"
`define ANSI_COLOR_YELLOW "\x1b[33m"
`define ANSI_COLOR_RESET "\x1b[0m"

module tb;

    localparam WIDTH = 32;
    logic               clk;
    logic [    WIDTH:0] a_ext;
    logic [    WIDTH:0] b_ext;
    logic [        1:0] control;
    logic [WIDTH - 1:0] res;
    logic [        3:0] flags;  // N Z C V

    alu u_alu (
        .a      (a_ext[WIDTH-1:0]),
        .b      (b_ext[WIDTH-1:0]),
        .control(control),
        .result (res),
        .flags  (flags)
    );


    localparam CLK_PERIOD = 5;
    initial begin
        clk <= '0;
        forever #(CLK_PERIOD / 2) clk <= ~clk;
    end

    logic carry, zero, neg, oflow;
    logic [WIDTH:0] res_ext;

    task trace();
        $write("%s[TRACE]%s", `ANSI_COLOR_YELLOW, `ANSI_COLOR_RESET);
        $write(" a:%h, b:%h, control:", a_ext[WIDTH-1:0], b_ext[WIDTH-1:0]);
        begin
            case (control)
                `ALU_ADD: $write("ALU_ADD");
                `ALU_SUB: $write("ALU_SUB");
                `ALU_AND: $write("ALU_AND");
                `ALU_OR:  $write("ALU_OR");
            endcase
        end
        $display(", flags N:%b Z:%b C:%b V:%b", |(flags & `ALU_FLAG_NEG), |(flags & `ALU_FLAG_ZERO),
                 |(flags & `ALU_FLAG_CARRY), |(flags & `ALU_FLAG_OFLOW));
    endtask

    initial begin

        repeat (1000) begin
            @(posedge clk);
            a_ext[WIDTH-1:0] = $urandom();
            b_ext[WIDTH-1:0] = $urandom();
            a_ext[WIDTH] = 0;
            b_ext[WIDTH] = 0;
            control = $urandom_range(0,3);

            #1;

            case (control)
                `ALU_ADD: res_ext = a_ext + b_ext;
                `ALU_SUB: res_ext = a_ext - b_ext;
                `ALU_AND: res_ext = a_ext & b_ext;
                `ALU_OR:  res_ext = a_ext | b_ext;
            endcase

            if (res_ext[WIDTH-1:0] !== res) begin
                $write("%s[ERROR]%s", `ANSI_COLOR_RED, `ANSI_COLOR_RESET);
                $display(" res mismatch, %h actual, %h expected", res, res_ext[WIDTH-1:0]);
                trace();
                $finish();
            end

            zero = res_ext[WIDTH-1:0] == WIDTH'(0);
            neg = res_ext[WIDTH-1];
            if(control == `ALU_ADD) begin
                carry = res_ext > 33'h0FFFFFFFF;
                oflow = (a_ext[WIDTH - 1] == b_ext[WIDTH - 1]) & (res_ext[WIDTH - 1] != a_ext[WIDTH - 1]);
            end
            else if (control == `ALU_SUB) begin
                carry = a_ext < b_ext;
                oflow = (a_ext[WIDTH - 1] != b_ext[WIDTH - 1]) & (res_ext[WIDTH - 1] != a_ext[WIDTH - 1]);
            end
            else begin
                carry = '0;
                oflow = '0;
            end

            if ({neg, zero, 'x, oflow} != flags) begin
                $write("%s[ERROR]%s", `ANSI_COLOR_RED, `ANSI_COLOR_RESET);
                $display(" flags mismatch, %b actual, %b expected", flags, {neg, zero, carry, oflow
                         });
                trace();
                $display("%b %b", res_ext, res);
                $finish();
            end
        end

        $write("%s[PASS] %s", `ANSI_COLOR_GREEN, `ANSI_COLOR_RESET);
        $write("%s", `__FILE__);
        $display();
        $finish();
    end

    initial begin
        $dumpvars();
    end


endmodule : tb
