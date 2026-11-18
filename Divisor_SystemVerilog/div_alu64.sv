// Proyecto corto 2 - divisor modular
// ============== ALU de 64 bits ==============
module div_alu64 (
    input  logic [63:0] a,
    input  logic [63:0] b,
    input  logic        subtract, // 1: a-b; 0: a+b
    output logic [63:0] result,
    output logic        negative  // Solo significativo en resta
);
    logic [64:0] extended_result;
    always_comb begin
        if (subtract)
            extended_result = {1'b0, a} - {1'b0, b};
        else
            extended_result = {1'b0, a} + {1'b0, b};
        result   = extended_result[63:0];
        negative = subtract && extended_result[64];
    end
endmodule
