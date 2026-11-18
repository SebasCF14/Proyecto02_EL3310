// Proyecto corto 2 - divisor modular
// ============== Unidad de control ==============
module div_control (
    input  logic clk, reset, start,
    input  logic trial_negative,
    input  logic divisor_is_zero,
    output logic load,
    output logic alu_subtract,
    output logic remainder_write,
    output logic divisor_shift,
    output logic quotient_shift,
    output logic quotient_bit,
    output logic capture_negative,
    output logic done,
    output logic div_by_zero
);
    typedef enum logic [2:0] {
        IDLE, SUBTRACT, TEST_RESTORE, SHIFT, DONE
    } state_t;
    state_t state, next_state;
    logic [5:0] iteration; // 0..32 = 33 iteraciones
    logic count_clear, count_increment;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            iteration <= '0;
        end else begin
            state <= next_state;
            if (count_clear)          iteration <= '0;
            else if (count_increment) iteration <= iteration + 1'b1;
        end
    end

    always_comb begin
        next_state       = state;
        load             = 1'b0;
        alu_subtract     = 1'b0;
        remainder_write  = 1'b0;
        divisor_shift    = 1'b0;
        quotient_shift   = 1'b0;
        quotient_bit     = 1'b0;
        capture_negative = 1'b0;
        done             = 1'b0;
        div_by_zero      = 1'b0;
        count_clear      = 1'b0;
        count_increment  = 1'b0;

        case (state)
            IDLE: if (start) begin
                load        = 1'b1;
                count_clear = 1'b1;
                if (divisor_is_zero) next_state = DONE;
                else                 next_state = SUBTRACT;
            end
            SUBTRACT: begin
                alu_subtract     = 1'b1;
                remainder_write  = 1'b1;
                capture_negative = 1'b1;
                next_state       = TEST_RESTORE;
            end
            TEST_RESTORE: begin
                // El residuo ya se resto. Si fue negativo se suma
                // nuevamente el divisor para recuperar el valor previo.
                if (trial_negative) remainder_write = 1'b1;
                quotient_shift = 1'b1;
                quotient_bit   = !trial_negative;
                next_state     = SHIFT;
            end
            SHIFT: begin
                divisor_shift = 1'b1;
                if (iteration == 6'd32) next_state = DONE;
                else begin
                    count_increment = 1'b1;
                    next_state      = SUBTRACT;
                end
            end
            DONE: begin
                done        = 1'b1;
                div_by_zero = divisor_is_zero;
                if (!start) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
