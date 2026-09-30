`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2026 09:53:54
// Design Name: 
// Module Name: ALU_Control_TB
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
module ALU_Control_TB;
    logic [1:0] ALU_op;
    logic [2:0] funct3;
    logic [6:0] funct7;
    logic [3:0] ALU_control;
    ALU_Control dut (.*);
    
task automatic check_signals(
    input string test_name,
    input logic [1:0] test_ALU_op,
    input logic [2:0] test_funct3,
    input logic [6:0] test_funct7,
    input logic [3:0] expected
);
    ALU_op = test_ALU_op;
    funct3 = test_funct3;
    funct7 = test_funct7;
    #1;

    if (ALU_control !== expected)
    $error("FAIL: %s expected %b got %b", test_name, expected, ALU_control);
    else
        $display("PASS: %s", test_name);
endtask
                
initial begin
    $display("Starting ALU_Control testbench");
    
    // ADD path for load and store address calculation
    check_signals("ALUOP_ADD -> ALU_ADD", ALUOP_ADD, F3_LW_SW, 7'b0000000, ALU_ADD);
    
    // Branches
    check_signals("BRANCH BEQ -> SUB", ALUOP_BRANCH, F3_BEQ, 7'b0000000, ALU_SUB);
    check_signals("BRANCH BNE -> SUB", ALUOP_BRANCH, F3_BNE, 7'b0000000, ALU_SUB);
    check_signals("BRANCH BLT -> SLT", ALUOP_BRANCH, F3_BLT, 7'b0000000, ALU_SLT);
    check_signals("BRANCH BGE -> SLT", ALUOP_BRANCH, F3_BGE, 7'b0000000, ALU_SLT);
    check_signals("BRANCH BLTU -> SLTU", ALUOP_BRANCH, F3_BLTU, 7'b0000000, ALU_SLTU);
    check_signals("BRANCH BGEU -> SLTU", ALUOP_BRANCH, F3_BGEU, 7'b0000000, ALU_SLTU);
  
  
    // R-TYPES
    check_signals("RTYPE ADD", ALUOP_RTYPE, F3_ADD_SUB, F7_ADD, ALU_ADD);
    check_signals("RTYPE SUB", ALUOP_RTYPE, F3_ADD_SUB, F7_SUB, ALU_SUB);
    check_signals("RTYPE AND", ALUOP_RTYPE, F3_AND, 7'b0000000, ALU_AND);
    check_signals("RTYPE OR", ALUOP_RTYPE, F3_OR, 7'b0000000, ALU_OR);
    check_signals("RTYPE XOR", ALUOP_RTYPE, F3_XOR, 7'b0000000, ALU_XOR);
    check_signals("RTYPE SLT", ALUOP_RTYPE, F3_SLT, 7'b0000000, ALU_SLT);
    check_signals("RTYPE SLTU", ALUOP_RTYPE, F3_SLTU, 7'b0000000, ALU_SLTU);
    check_signals("RTYPE SLL", ALUOP_RTYPE, F3_SLL, 7'b0000000, ALU_SLL);
    check_signals("RTYPE SRL", ALUOP_RTYPE, F3_SRL_SRA, 7'b0000000, ALU_SRL);
    check_signals("RTYPE SRA", ALUOP_RTYPE, F3_SRL_SRA, F7_SUB, ALU_SRA);
    
    // I-TYPES
    check_signals("ITYPE ADDI", ALUOP_ITYPE, F3_ADD_SUB, 7'b0000000, ALU_ADD);
    check_signals("ITYPE ANDI", ALUOP_ITYPE, F3_AND, 7'b0000000, ALU_AND);
    check_signals("ITYPE ORI", ALUOP_ITYPE, F3_OR, 7'b0000000, ALU_OR);
    check_signals("ITYPE XORI", ALUOP_ITYPE, F3_XOR, 7'b0000000, ALU_XOR);
    check_signals("ITYPE SLTI", ALUOP_ITYPE, F3_SLT, 7'b0000000, ALU_SLT);
    check_signals("ITYPE SLTIU", ALUOP_ITYPE, F3_SLTU, 7'b0000000, ALU_SLTU);
    check_signals("ITYPE SLLI", ALUOP_ITYPE, F3_SLL, 7'b0000000, ALU_SLL);
    check_signals("ITYPE SRLI", ALUOP_ITYPE, F3_SRL_SRA, 7'b0000000, ALU_SRL);
    check_signals("ITYPE SRAI", ALUOP_ITYPE, F3_SRL_SRA, F7_SRA, ALU_SRA);
    
    $display("ALU_Control testbench finished");
    $finish;
end
    
    
endmodule
