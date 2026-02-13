`timescale 1ns/1ps

module digital_locker (
    input clk,
    input rst,

    input [3:0] keypad_in,
    input start,
    input enter,
    input set_pin,
    input store,
    input read,
    input tamper,

    output reg unlocked,
    output reg locked,
    output reg locked_out,
    output reg fail,
    output reg [15:0] data_out
);

    // FSM States
    parameter IDLE      = 3'b000,
              ENTERING  = 3'b001,
              VERIFY    = 3'b010,
              UNLOCKED  = 3'b011,
              ERROR     = 3'b100,
              LOCKOUT   = 3'b101;

    reg [2:0] state, next_state;

    reg [15:0] pin_reg;
    reg [15:0] entered_pin;
    reg [15:0] stored_data;
    reg [15:0] store_buffer;

    reg [2:0] digit_count;
    reg [1:0] wrong_attempts;
    reg [3:0] lockout_counter;

    // =============================
    // Sequential Logic
    // =============================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            pin_reg <= 16'h4321;   // default PIN: 4-3-2-1
            entered_pin <= 0;
            stored_data <= 0;
            store_buffer <= 0;
            digit_count <= 0;
            wrong_attempts <= 0;
            lockout_counter <= 0;
            locked_out <= 0;
        end 
        else begin
            state <= next_state;

            // Tamper detection
            if (tamper) begin
                locked_out <= 1;
                wrong_attempts <= 3;
            end

            // PIN entry shifting
            if (enter && state == ENTERING) begin
                entered_pin <= {entered_pin[11:0], keypad_in};
                digit_count <= digit_count + 1;
            end

            // Data entry while unlocked
            if (enter && state == UNLOCKED) begin
                store_buffer <= {store_buffer[11:0], keypad_in};
            end

            // Start resets entry counters
            if (start) begin
                digit_count <= 0;
                entered_pin <= 0;
                store_buffer <= 0;
            end

            // Wrong attempt counter
            if (state == VERIFY && entered_pin != pin_reg)
                wrong_attempts <= wrong_attempts + 1;
            else if (state == UNLOCKED)
                wrong_attempts <= 0;

            // Lockout counter
            if (state == LOCKOUT)
                lockout_counter <= lockout_counter + 1;
            else
                lockout_counter <= 0;

            // PIN update
            if (state == UNLOCKED && set_pin && digit_count == 4)
                pin_reg <= entered_pin;

            // Store data
            if (state == UNLOCKED && store && digit_count == 4)
                stored_data <= store_buffer;

            // Lockout recovery
            if (state == LOCKOUT && lockout_counter == 10) begin
                locked_out <= 0;
                wrong_attempts <= 0;
            end
        end
    end

    // =============================
    // Combinational Logic
    // =============================
    always @(*) begin
        next_state = state;

        locked = 1;
        unlocked = 0;
        fail = 0;
        data_out = 0;

        case (state)

            IDLE:
                if (locked_out)
                    next_state = LOCKOUT;
                else if (start)
                    next_state = ENTERING;

            ENTERING:
                if (digit_count == 4)
                    next_state = VERIFY;

            VERIFY:
                if (entered_pin == pin_reg)
                    next_state = UNLOCKED;
                else if (wrong_attempts >= 2)
                    next_state = LOCKOUT;
                else
                    next_state = ERROR;

            UNLOCKED: begin
                locked = 0;
                unlocked = 1;
                if (read)
                    data_out = stored_data;
                if (start)
                    next_state = ENTERING;
            end

            ERROR: begin
                fail = 1;
                if (start)
                    next_state = ENTERING;
            end

            LOCKOUT: begin
                fail = 1;
                if (lockout_counter == 10)
                    next_state = IDLE;
            end

        endcase
    end

endmodule
