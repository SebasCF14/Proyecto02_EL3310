// Este es el banco de pruebas que vamos a utilizar para verificar el correcto comportamiento
// de nuestro multiplicador :)
`timescale 1ns / 1ps

module testbench_top;

    logic        clk;
    logic        reset;
    logic        start;
    logic [63:0] multiplicand_in;
    logic [31:0] multiplier_in;
    logic [63:0] product_out;
    logic        done;

    // Instanciación del módulo Top
    top uut (
        .clk            (clk),
        .reset          (reset),
        .start          (start),
        .multiplicand_in(multiplicand_in),
        .multiplier_in  (multiplier_in),
        .product_out    (product_out),
        .done           (done)
    );

    // Generación de reloj (Periodo = 10ns -> f = 100 MHz)
    always #5 clk = ~clk;

    // Task auxiliar para ejecutar una multiplicación y verificar el resultado
    task automatic run_test(
        input logic [63:0] a,
        input logic [31:0] b,
        input string       test_name
    );
        logic [63:0] expected_product;
        expected_product = a * b;

        // Cargar operandos e iniciar
        @ (posedge clk);
        multiplicand_in = a;
        multiplier_in   = b;
        start           = 1'b1;
        
        @ (posedge clk);
        start           = 1'b0;

        // Unidad de control completando las 32 repeticiones
        wait (done == 1'b1);
        @ (posedge clk);

        // Comprobación de resultados
        if (product_out === expected_product) begin
            $display("[APROBADO] %s: %0d * %0d = %0d", test_name, a, b, product_out);
        end else begin
            $display("[ERROR] %s: %0d * %0d | Esperado: %0d, Obtenido: %0d", 
                     test_name, a, b, expected_product, product_out);
        end
        
        // Pausa entre pruebas
        #20;
    endtask

    // Bloque de estímulos inicial
    initial begin
        // Configuración para volcado de formas de onda (Waveforms)
        $dumpfile("testbench_top.vcd");
        $dumpvars(0, testbench_top);

        // Inicializar señales
        clk             = 0;
        reset           = 1;
        start           = 0;
        multiplicand_in = 0;
        multiplier_in   = 0;

        // Liberar reset tras 20 ns
        #20;
        reset = 0;
        #10;

        $display("Inicio de pruebas para el Multiplicador");

        // Caso 1: Multiplicación normal (15 * 10 = 150)
        run_test(64'd15, 32'd10, "Caso 1: Basico");

        // Caso 2: Multiplicación por cero
        run_test(64'd1234567, 32'd0, "Caso 2: Por Cero");

        // Caso 3: Multiplicación por uno
        run_test(64'd987654321, 32'd1, "Caso 3: Por Uno");

        // Caso 4: Operandos de mayor escala (32 bits max x valor amplio)
        run_test(64'h00000000FFFFFFFF, 32'hFFFFFFFF, "Caso 4: Max 32-bit");

        // Caso 5: Valores arbitrarios grandes
        run_test(64'd500000, 32'd40000, "Caso 5: Escala Media");

        $display("Aquí termina la prueba ;)");
        $finish;
    end

endmodule