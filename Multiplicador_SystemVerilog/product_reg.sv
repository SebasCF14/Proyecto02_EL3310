module product_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        load,     // Añade señal al Load
    input  logic        write_en, // "Write"
    input  logic [63:0] d_in,     // Valor que proviene de la salida de la ALU
    output logic [63:0] d_out     // Valor actual (se conecta a la entrada B de la ALU)
);

always_ff @(posedge clk or posedge reset) begin
        if (reset)
            d_out <= '0;          // Limpia al hacer reset general
        else if (load)
            d_out <= '0;          // Limpia el producto a 0 al iniciar cada multiplicación
        else if (write_en)
            d_out <= d_in;        // Guarda la nueva suma de la ALU
    end

endmodule