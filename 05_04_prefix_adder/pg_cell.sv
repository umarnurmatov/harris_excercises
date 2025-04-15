// propagate-generate cell
module pg_cell (
    input p_upper,  // P i:k
    input p_lower,  // P k-1:j
    input g_upper,  // G i:k
    input g_lower,  // G k-1:j

    output p,  // P i:j
    output g   // G i:j
);

    assign p = p_upper & p_lower;
    assign g = (p_upper & g_lower) | g_upper;

endmodule : pg_cell
