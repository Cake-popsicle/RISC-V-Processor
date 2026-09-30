`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2026 09:53:54
// Design Name: 
// Module Name: ALU_TB
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


import Definitions::*;

module ALU_TB;
logic [31:0] A;
logic [31:0] B;
logic [3:0] ALU_control;
logic [31:0] result;

ALU dut (.*);

task automatic check_signals(
    input string test_name,
    input logic [31:0] expected_result
);
    #1;
    if (result !== expected_result) begin
        $error("FAIL: %s expected result=%h got result=%h",
               test_name, expected_result, result);
    end
    else begin
        $display("PASS: %s", test_name);
    end
endtask

initial begin
    $display("Starting ALU testbench");

    A = 32'd10; B = 32'd5; ALU_control = ALU_ADD;
    check_signals("ADD", 32'd15);

    A = 32'd5; B = 32'd5; ALU_control = ALU_SUB;
    check_signals("SUB to zero", 32'd0);

    A = 32'hF0F0_F0F0; B = 32'h0FF0_00FF; ALU_control = ALU_AND;
    check_signals("AND", 32'h00F0_00F0);

    A = 32'hF0F0_0000; B = 32'h0FF0_00FF; ALU_control = ALU_OR;
    check_signals("OR", 32'hFFF0_00FF);

    A = 32'hAAAA_5555; B = 32'hFFFF_0000; ALU_control = ALU_XOR;
    check_signals("XOR", 32'h5555_5555);

    A = 32'd1; B = 32'd4; ALU_control = ALU_SLL;
    check_signals("SLL", 32'd16);

    A = 32'h8000_0000; B = 32'd4; ALU_control = ALU_SRL;
    check_signals("SRL", 32'h0800_0000);

    A = 32'h8000_0000; B = 32'd4; ALU_control = ALU_SRA;
    check_signals("SRA", 32'hF800_0000);

    A = -32'sd2; B = 32'd1; ALU_control = ALU_SLT;
    check_signals("SLT signed", 32'd1);

    A = 32'hFFFF_FFFF; B = 32'd1; ALU_control = ALU_SLTU;
    check_signals("SLTU unsigned", 32'd0);

    $display("ALU testbench finished");
    $finish;
end
endmodule
