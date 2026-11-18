`timescale 1ns/1ps
module testbench_divisor;
    logic clk = 1'b0;
    logic reset = 1'b0;
    logic start = 1'b0;
    logic [31:0] dividend = 0, divisor = 0;
    logic [31:0] quotient, remainder;
    logic done, div_by_zero;
    integer passed = 0;
    integer cycles;

    always #5 clk = ~clk;

    divisor_top dut (
        .clk(clk), .reset(reset), .start(start),
        .dividend(dividend), .divisor(divisor),
        .quotient(quotient), .remainder(remainder),
        .done(done), .div_by_zero(div_by_zero)
    );

    task automatic check_division(input logic [31:0] a, b);
        logic [31:0] expected_q, expected_r;
        begin
            // Cambiar senales lejos del flanco positivo evita carreras.
            @(negedge clk);
            dividend = a;
            divisor  = b;
            start    = 1'b1;
            @(negedge clk);  // carga inicial
            cycles = 0;
            while (!done && cycles < 110) begin
                @(negedge clk);
                cycles = cycles + 1;
            end
            if (!done) $fatal(1, "TIMEOUT: %0d / %0d", a, b);

            if (b == 0) begin
                if (!div_by_zero)
                    $fatal(1, "FALLO: no se detecto division entre cero");
                $display("OK: %0d / 0 -> div_by_zero=1", a);
            end else begin
                expected_q = a / b;
                expected_r = a % b;
                if (div_by_zero || quotient !== expected_q || remainder !== expected_r)
                    $fatal(1,
                        "FALLO: %0d / %0d => q=%0d r=%0d (esperado q=%0d r=%0d)",
                        a, b, quotient, remainder, expected_q, expected_r);
                $display("OK: %0d / %0d => cociente=%0d residuo=%0d (%0d ciclos)",
                         a, b, quotient, remainder, cycles);
            end
            passed = passed + 1;
            // El controlador libera DONE cuando start vuelve a cero.
            @(negedge clk);
            start = 1'b0;
            @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("divisor.vcd");
        $dumpvars(0, testbench_divisor);
        reset = 1'b1;
        repeat (2) @(negedge clk);
        reset = 1'b0;

        check_division(32'd13, 32'd3);          // 4, resto 1
        check_division(32'd100, 32'd5);         // exacta
        check_division(32'd7, 32'd20);          // cociente 0
        check_division(32'd0, 32'd9);           // dividendo 0
        check_division(32'd4294967295, 32'd1); // limite alto
        check_division(32'd4294967295, 32'd4294967295);
        check_division(32'd4294967295, 32'd2147483648);
        check_division(32'd1234567890, 32'd12345);
        check_division(32'd42, 32'd0);         // error controlado

        $display("TODAS LAS PRUEBAS APROBADAS: %0d", passed);
        $finish;
    end
endmodule
