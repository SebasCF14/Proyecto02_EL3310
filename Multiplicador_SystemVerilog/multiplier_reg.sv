module multiplier_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        load,        // Señal para cargar el multiplicador inicial
    input  logic        shift_right, // Señal de control para desplazar
    input  logic [31:0] d_in,        // Valor de entrada (32 bits)
    output logic [31:0] d_out        // Valor actual almacenado
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            d_out <= '0;
        else if (load)
            d_out <= d_in;
        else if (shift_right)
            d_out <= d_out >> 1;     // Desplazamiento a la derecha
    end

endmodule