`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2026 11:50:30
// Design Name: 
// Module Name: Instruction_Memory_TB
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


module Instruction_Memory_TB;
logic clk;
logic [31:0] address;
logic [31:0] instruction;

Instruction_Memory dut (.*);

always #1 clk = ~clk;

task automatic check_signals(input string name, input logic [31:0] actual, input logic [31:0] expected);
    if (actual !== expected)
        $error("FAIL: %s expected %h got %h", name, expected, actual);
    else
        $display("PASS: %s", name);
endtask

initial begin
    $display("Starting Instruction_Memory testbench");
    clk = 0;
    address = 32'b0;

    // Override selected entries with known values for deterministic checks
    dut.memory[0] = 32'h0000_0013;
    dut.memory[1] = 32'h0010_8093;
    dut.memory[2] = 32'h0021_0113;
    dut.memory[3] = 32'h0031_8193;

    // Address 0x0 maps to word 0
    @(posedge clk);
    address = 32'h0000_0000;
    #0;
    check_signals("Read word 0 @0x0", instruction, 32'h0000_0013);

    // Byte offsets 0x4..0x7 map to word 1
    @(posedge clk);
    address = 32'h0000_0004;
    #0;
    check_signals("Read word 1 @0x4", instruction, 32'h0010_8093);

    @(posedge clk);
    address = 32'h0000_0007;
    #0;
    check_signals("Alignment via address[31:2]", instruction, 32'h0010_8093);

    // Next words
    @(posedge clk);
    address = 32'h0000_0008;
    #0;
    check_signals("Read word 2 @0x8", instruction, 32'h0021_0113);

    @(posedge clk);
    address = 32'h0000_000C;
    #0;
    check_signals("Read word 3 @0xC", instruction, 32'h0031_8193);

    $display("Instruction_Memory testbench finished");
    $finish;
end
endmodule
