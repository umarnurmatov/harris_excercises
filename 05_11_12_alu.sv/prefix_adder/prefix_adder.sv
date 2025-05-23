`ifndef PREFIX_ADDER_32
`define PREFIX_ADDER_32

// Ladner-Fischer prefix net
module prefix_adder_32 (
    input [N-1:0] a,
    input [N-1:0] b,
    input         c_in,

    output [N-1:0] sum,
    output         c_out
);

    localparam N = 32;

    // layer -1
    wire [N - 1:0] prg;  // propagate 30:-1
    wire [N - 1:0] gen;  // generate 30:-1

    assign prg[0] = 0;
    assign gen[0] = c_in;

    assign prg[N-1:1] = a[N-2:0] | b[N-2:0];
    assign gen[N-1:1] = a[N-2:0] & b[N-2:0];

    // layer 0
    wire [N - 1:0] layer_0_p;  // 30:-1
    wire [N - 1:0] layer_0_g;  // 30:-1

    generate
        for (genvar i = 0; i < N; i += 2) begin
            pg_cell u_pg_cell (
                .p_upper(prg[i+1]),
                .p_lower(prg[i]),
                .g_upper(gen[i+1]),
                .g_lower(gen[i]),
                .p      (layer_0_p[i+1]),
                .g      (layer_0_g[i+1])
            );
            assign layer_0_p[i] = prg[i];
            assign layer_0_g[i] = gen[i];
        end
    endgenerate

    // layer 1
    wire [N - 1:0] layer_1_p;  // 30:-1
    wire [N - 1:0] layer_1_g;  // 30:-1

    generate
        for (genvar i = 0; i < N; i += 4) begin
            for (genvar j = 1; j <= 2; ++j) begin
                pg_cell u_pg_cell (
                    .p_upper(layer_0_p[i+1+j]),
                    .p_lower(layer_0_p[i+1]),
                    .g_upper(layer_0_g[i+1+j]),
                    .g_lower(layer_0_g[i+1]),
                    .p      (layer_1_p[i+1+j]),
                    .g      (layer_1_g[i+1+j])
                );
                assign layer_1_p[i-1+j] = layer_0_p[i-1+j];
                assign layer_1_g[i-1+j] = layer_0_g[i-1+j];
            end
        end
    endgenerate

    // layer 2
    wire [N - 1:0] layer_2_p;  // 30:-1
    wire [N - 1:0] layer_2_g;  // 30:-1

    generate
        for (genvar i = 0; i < N; i += 8) begin
            for (genvar j = 1; j <= 4; ++j) begin
                pg_cell u_pg_cell (
                    .p_upper(layer_1_p[i+3+j]),
                    .p_lower(layer_1_p[i+3]),
                    .g_upper(layer_1_g[i+3+j]),
                    .g_lower(layer_1_g[i+3]),
                    .p      (layer_2_p[i+3+j]),
                    .g      (layer_2_g[i+3+j])
                );
                assign layer_2_p[i-1+j] = layer_1_p[i-1+j];
                assign layer_2_g[i-1+j] = layer_1_g[i-1+j];
            end
        end
    endgenerate

    // layer 3
    wire [N - 1:0] layer_3_p;  // 30:-1
    wire [N - 1:0] layer_3_g;  // 30:-1

    generate
        for (genvar i = 0; i < N; i += 16) begin
            for (genvar j = 1; j <= 8; ++j) begin
                pg_cell u_pg_cell (
                    .p_upper(layer_2_p[i+7+j]),
                    .p_lower(layer_2_p[i+7]),
                    .g_upper(layer_2_g[i+7+j]),
                    .g_lower(layer_2_g[i+7]),
                    .p      (layer_3_p[i+7+j]),
                    .g      (layer_3_g[i+7+j])
                );
                assign layer_3_p[i-1+j] = layer_2_p[i-1+j];
                assign layer_3_g[i-1+j] = layer_2_g[i-1+j];
            end
        end
    endgenerate

    // layer 4
    wire [N - 1:0] layer_4_p;  // 30:-1
    wire [N - 1:0] layer_4_g;  // 30:-1

    generate
        for (genvar i = 0; i < N; i += 32) begin
            for (genvar j = 1; j <= 16; ++j) begin
                pg_cell u_pg_cell (
                    .p_upper(layer_3_p[i+15+j]),
                    .p_lower(layer_3_p[i+15]),
                    .g_upper(layer_3_g[i+15+j]),
                    .g_lower(layer_3_g[i+15]),
                    .p      (layer_4_p[i+15+j]),
                    .g      (layer_4_g[i+15+j])
                );
                assign layer_4_p[i-1+j] = layer_3_p[i-1+j];
                assign layer_4_g[i-1+j] = layer_3_g[i-1+j];
            end
        end
    endgenerate

    // sum layer
    generate
        for (genvar i = 0; i < N; ++i) begin
            s_cell u_s_cell (
                .a(a[i]),
                .b(b[i]),
                .g(layer_4_g[i]),
                .s(sum[i])
            );
        end
    endgenerate

    assign c_out = layer_4_g[N-1];


endmodule : prefix_adder_32

`endif