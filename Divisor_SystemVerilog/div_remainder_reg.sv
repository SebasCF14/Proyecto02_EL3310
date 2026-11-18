// Proyecto corto 2 - divisor modular
// ============== Registro residuo (64 bits) ==============
module div_remainder_reg (
    input  logic        clk, reset, load, write_en,
    input  logic [31:0] dividend,
    input  logic [63:0] alu_result,
    output logic [63:0] q
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)         q <= '0;
        else if (load)     q <= {32'b0, dividend};
        else if (write_en) q <= alu_result;
    end
endmodule
