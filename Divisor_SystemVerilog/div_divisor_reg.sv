// Proyecto corto 2 - divisor modular
// ============== Registro divisor (64 bits) ==============
module div_divisor_reg (
    input  logic        clk, reset, load, shift_right,
    input  logic [31:0] d_in,
    output logic [63:0] q
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)            q <= '0;
        else if (load)        q <= {d_in, 32'b0};
        else if (shift_right) q <= q >> 1;
    end
endmodule
