// Proyecto corto 2 - divisor modular
// ============== Top del divisor ==============
module divisor_top (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,
    input  logic [31:0] dividend,
    input  logic [31:0] divisor,
    output logic [31:0] quotient,
    output logic [31:0] remainder,
    output logic        done,
    output logic        div_by_zero
);
    logic [63:0] divisor_value, remainder_value, alu_result;
    logic load, alu_subtract, remainder_write, divisor_shift;
    logic quotient_shift, quotient_bit, capture_negative;
    logic trial_negative, alu_negative;
    logic divisor_is_zero;

    assign divisor_is_zero = (divisor == 32'd0);
    assign remainder = remainder_value[31:0];

    div_alu64 alu (
        .a(remainder_value), .b(divisor_value),
        .subtract(alu_subtract), .result(alu_result),
        .negative(alu_negative)
    );
    div_divisor_reg divisor_register (
        .clk(clk), .reset(reset), .load(load), .shift_right(divisor_shift),
        .d_in(divisor), .q(divisor_value)
    );
    div_remainder_reg remainder_register (
        .clk(clk), .reset(reset), .load(load), .write_en(remainder_write),
        .dividend(dividend), .alu_result(alu_result), .q(remainder_value)
    );
    div_quotient_reg quotient_register (
        .clk(clk), .reset(reset), .load(load), .shift_left(quotient_shift),
        .quotient_bit(quotient_bit), .q(quotient)
    );
    always_ff @(posedge clk or posedge reset) begin
        if (reset) trial_negative <= 1'b0;
        else if (load) trial_negative <= 1'b0;
        else if (capture_negative) trial_negative <= alu_negative;
    end
    div_control controller (
        .clk(clk), .reset(reset), .start(start),
        .trial_negative(trial_negative), .divisor_is_zero(divisor_is_zero),
        .load(load), .alu_subtract(alu_subtract),
        .remainder_write(remainder_write), .divisor_shift(divisor_shift),
        .quotient_shift(quotient_shift), .quotient_bit(quotient_bit),
        .capture_negative(capture_negative), .done(done),
        .div_by_zero(div_by_zero)
    );
endmodule
