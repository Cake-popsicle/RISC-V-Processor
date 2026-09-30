`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2026 11:18:49
// Design Name: 
// Module Name: Program_Counter_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Program_Counter_TB;
logic clk;
logic reset;
logic [31:0] next_pc;
logic [31:0] pc;

Program_Counter dut (.*);

always #1 clk = ~clk;

task automatic check_signals(
    input string name,
    input logic [31:0] actual,
    input logic [31:0] expected
);
    if (actual !== expected)
        $error("FAIL: %s expected %h got %h", name, expected, actual);
    else
        $display("PASS: %s", name);
endtask

initial begin
    $display("Starting Program_Counter testbench");

    clk = 0;
    reset = 1;
    next_pc = 32'h0000_0000;

    // Let reset be seen
    repeat (2) @(posedge clk);
    #0.1;
    check_signals("Reset drives pc to zero", pc, 32'h0000_0000);

    // Set reset to 0 and load first address
    reset = 0;
    next_pc = 32'h0000_0004;

    @(posedge clk);
    #0.1;
    check_signals("pc loads next_pc after posedge", pc, 32'h0000_0004);

    // Move to another address
    next_pc = 32'h0000_0010;

    @(posedge clk);
    #0.1;
    check_signals("pc updates to new next_pc", pc, 32'h0000_0010);

    // Hold value between clock edges
    next_pc = 32'h0000_0020;
    #0.5;
    check_signals("pc holds between edges", pc, 32'h0000_0010);

    @(posedge clk);
    #0.1;
    check_signals("pc updates on next posedge", pc, 32'h0000_0020);

    // Asynchronous reset should override pc immediately
    reset = 1;
    #0.1;
    check_signals("async reset clears pc immediately", pc, 32'h0000_0000);

    // Recover from reset and continue
    reset = 0;
    next_pc = 32'h0000_0100;

    @(posedge clk);
    #0.1;
    check_signals("pc resumes after reset", pc, 32'h0000_0100);

    $display("Program_Counter testbench finished");
    $finish;
end
endmodule
