// Proyecto corto 2 - divisor modular
// ============== Registro cociente (32 bits) ==============
module div_quotient_reg (
    input  logic        clk, reset, load, shift_left,
    input  logic        quotient_bit,
    output logic [31:0] q
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)           q <= '0;
        else if (load)       q <= '0;
        else if (shift_left) q <= {q[30:0], quotient_bit};
    end
endmodule
