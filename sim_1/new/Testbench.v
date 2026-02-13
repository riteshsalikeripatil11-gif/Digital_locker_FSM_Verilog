`timescale 1ns/1ps

module digital_locker_tb;

reg clk, rst;
reg [3:0] keypad_in;
reg start, enter, set_pin, store, read, tamper;

wire unlocked, locked, locked_out, fail;
wire [15:0] data_out;

digital_locker uut (
    .clk(clk),
    .rst(rst),
    .keypad_in(keypad_in),
    .start(start),
    .enter(enter),
    .set_pin(set_pin),
    .store(store),
    .read(read),
    .tamper(tamper),
    .unlocked(unlocked),
    .locked(locked),
    .locked_out(locked_out),
    .fail(fail),
    .data_out(data_out)
);

// Clock generation
always #5 clk = ~clk;

// Task to press one digit
task press_digit;
    input [3:0] val;
    begin
        keypad_in = val;
        enter = 1; #10;
        enter = 0; #10;
    end
endtask

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, digital_locker_tb);

    $display("Starting Simulation...");
    $monitor("Time=%0t | unlocked=%b locked=%b fail=%b locked_out=%b data=%h",
              $time, unlocked, locked, fail, locked_out, data_out);

    clk = 0;
    rst = 1;
    keypad_in = 0;
    start = 0;
    enter = 0;
    set_pin = 0;
    store = 0;
    read = 0;
    tamper = 0;

    #20 rst = 0;

    // Correct PIN: 4-3-2-1
    start = 1; #20; start = 0;
    press_digit(4);
    press_digit(3);
    press_digit(2);
    press_digit(1);
    #40;

    // Store data 7-8-7-8
    press_digit(7);
    press_digit(8);
    press_digit(7);
    press_digit(8);
    store = 1; #20; store = 0;

    // Read stored data
    read = 1; #20; read = 0;

    // Three wrong attempts
    repeat(3) begin
        start = 1; #20; start = 0;
        press_digit(9);
        press_digit(9);
        press_digit(9);
        press_digit(9);
        #40;
    end

    #200;
    $display("Simulation Completed");
    $finish;
end

endmodule
