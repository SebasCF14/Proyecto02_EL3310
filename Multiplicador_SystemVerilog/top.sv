module top (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,
    input  logic [63:0] multiplicand_in, // Dato inicial a multiplicar
    input  logic [31:0] multiplier_in,   // Dato multiplicador inicial
    output logic [63:0] product_out,     // Resultado final
    output logic        done             // Indicador de finalización
);



    // Señales internas para interconectar los módulos
    // Señales de la Unidad de Control
    logic load;
    logic write_en;
    logic shift_left;
    logic shift_right;
    
    // Señales de datos entre registros y ALU
    logic [63:0] multiplicand_val;
    logic [31:0] multiplier_val;
    logic [63:0] product_val;
    logic [63:0] alu_result;

    // Bit menos significativo del multiplicador (para la unidad de control)
    logic multiplier_0;
    assign multiplier_0 = multiplier_val[0];

    // Asignar el registro del producto a la salida del módulo
    assign product_out = product_val;



    // Instanciación de los módulos (Datapath y Control)
    // 1. Unidad de Control
    control u_control (
        .clk         (clk),
        .reset       (reset),
        .start       (start),
        .multiplier_0(multiplier_0),
        .load        (load),
        .write_en    (write_en),
        .shift_left  (shift_left),
        .shift_right (shift_right),
        .done        (done)
    );

    // 2. Registro del Multiplicando (64 bits, shift left)
    multiplicand_reg u_multiplicand (
        .clk         (clk),
        .reset       (reset),
        .load        (load),
        .shift_left  (shift_left),
        .d_in        (multiplicand_in),
        .d_out       (multiplicand_val)
    );

    // 3. Registro del Multiplicador (32 bits, shift right)
    multiplier_reg u_multiplier (
        .clk         (clk),
        .reset       (reset),
        .load        (load),
        .shift_right (shift_right),
        .d_in        (multiplier_in),
        .d_out       (multiplier_val)
    );

    // 4. ALU de 64 bits
    alu64 u_alu (
        .a           (multiplicand_val),
        .b           (product_val),
        .result      (alu_result)
    );

// 5. Registro del Producto
    product_reg u_product (
        .clk         (clk),
        .reset       (reset),
        .load        (load),      //  Añadir conexión
        .write_en    (write_en),
        .d_in        (alu_result),
        .d_out       (product_val)
    );

endmodule