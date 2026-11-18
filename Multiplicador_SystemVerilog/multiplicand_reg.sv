module multiplicand_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        load,       // Señal para cargar el multiplicando inicial
    input  logic        shift_left, // Señal de control para desplazar
    input  logic [63:0] d_in,       // Valor de entrada
    output logic [63:0] d_out       // Valor actual almacenado
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            d_out <= '0;            // Limpia el registro a 0
        else if (load)
            d_out <= d_in;          // Carga inicial
        else if (shift_left)
            d_out <= d_out << 1;    // Desplazamiento a la izquierda
    end

endmodule