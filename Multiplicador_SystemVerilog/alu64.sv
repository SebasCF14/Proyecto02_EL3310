// Arreglo inspirado en la implementación de 64-Bits ALU de A. Khan.
module alu64 (
    input  logic [63:0] a,       // Operando A (Multiplicand)
    input  logic [63:0] b,       // Operando B (Product)
    output logic [63:0] result   // Resultado de la suma
);

    always_comb begin
        result = a + b;
    end

endmodule