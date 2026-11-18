module control (
    input  logic clk,
    input  logic reset,
    input  logic start,          // Señal para iniciar la multiplicación
    input  logic multiplier_0,   // Bit menos significativo del multiplicador (Test)
    
    // Señales de control hacia el Datapath
    output logic load,           // Carga inicial de registros
    output logic write_en,       // Habilita la escritura en el registro Product (Write)
    output logic shift_left,     // Habilita desplazamiento en Multiplicand
    output logic shift_right,    // Habilita desplazamiento en Multiplier
    output logic done            // Indica que la multiplicación terminó
);

    // Estados de la FSM
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        ADD   = 2'b01,
        SHIFT = 2'b10,
        DONE  = 2'b11
    } state;

    state current_state, next_state;
    
    // Contador de 6 bits para llegar hasta 32 repeticiones (0 a 31)
    logic [5:0] counter;
    logic reset_counter;
    logic inc_counter;

    // Actualización de estado y contador
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            counter       <= '0;
        end else begin
            current_state <= next_state;
            
            if (reset_counter)
                counter <= '0;
            else if (inc_counter)
                counter <= counter + 1'b1;
        end
    end

    // Cálculo del siguiente estado y salidas
    always_comb begin
        next_state    = current_state;
        load          = 1'b0;
        write_en      = 1'b0;
        shift_left    = 1'b0;
        shift_right   = 1'b0;
        done          = 1'b0;
        reset_counter = 1'b0;
        inc_counter   = 1'b0;

        case (current_state)
            IDLE: begin
                if (start) begin
                    load          = 1'b1;
                    reset_counter = 1'b1;
                    next_state    = ADD;
                end
            end

            ADD: begin
                // 1) Test Multiplier0 = 1 -> Add multiplicand to product
                if (multiplier_0) begin
                    write_en = 1'b1; 
                end
                next_state = SHIFT;
            end

            SHIFT: begin
                // 2) Shift left
                // 3) Shift right
                shift_left  = 1'b1;
                shift_right = 1'b1;
                inc_counter = 1'b1;

                // Verification ¿32nd repetition?
                if (counter == 6'd31) begin 
                    next_state = DONE;  // Yes: 32 repetitions
                end else begin
                    next_state = ADD;   // No: <32 repetitions
                end
            end

            DONE: begin
                done = 1'b1;
                // Mantener estado DONE hasta que se baje la bandera start
                if (!start) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule