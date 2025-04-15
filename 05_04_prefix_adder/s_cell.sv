module s_cell (
    input  a,  //a[i]
    input  b,  //b[i]
    input  g,  //G[i-1:-1]
    output s   //sum[i]
);

    assign s = (a ^ b) ^ g;

endmodule : s_cell
