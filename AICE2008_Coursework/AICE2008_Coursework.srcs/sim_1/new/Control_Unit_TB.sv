`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2026 09:53:54
// Design Name: 
// Module Name: Control_Unit_TB
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
module Control_Unit_TB;

logic [6:0] opcode;
logic reg_write, mem_read, mem_write, mem_to_reg,ALU_src, branch, jump, jalr;
logic [1:0] ALU_op;
Control_Unit dut (.*);
    
task automatic check_signals(
    input string name,
    input logic exp_reg_write,
    input logic exp_mem_read,
    input logic exp_mem_write,
    input logic exp_mem_to_reg,
    input logic exp_ALU_src,
    input logic exp_branch,
    input logic exp_jump,
    input logic exp_jalr,
    input logic [1:0] exp_ALU_op
);
    #1;
    if (reg_write !== exp_reg_write ||
        mem_read  !== exp_mem_read  ||
        mem_write !== exp_mem_write ||
        mem_to_reg !== exp_mem_to_reg ||
        ALU_src !== exp_ALU_src ||
        branch !== exp_branch ||
        jump !== exp_jump ||
        jalr !== exp_jalr ||
        ALU_op !== exp_ALU_op) begin
        $error("FAIL: %s got rw=%0b mr=%0b mw=%0b m2r=%0b as=%0b br=%0b j=%0b jr=%0b op=%b",
               name, reg_write, mem_read, mem_write, mem_to_reg, ALU_src, branch, jump, jalr, ALU_op);
    end
    else begin
        $display("PASS: %s", name);
    end
endtask

initial begin
    $display("Starting Control_Unit testbench");


    // Testing R-type instruction
    opcode = OP_RTYPE;
    check_signals("R-type", 1,0,0,0,0,0,0,0, ALUOP_RTYPE);


    // Testing I-type instruction
    opcode = OP_IMM;
   check_signals("I-type", 1,0,0,0,1,0,0,0, ALUOP_ITYPE);


    // Testing load instruction
    opcode = OP_LOAD;
    check_signals("LOAD", 1,1,0,1,1,0,0,0, ALUOP_ADD);

    // Testing store instruction
    opcode = OP_STORE;
    check_signals("STORE", 0,0,1,0,1,0,0,0, ALUOP_ADD);


    // Testing branch instruction
    opcode = OP_BRANCH;
    check_signals("BRANCH", 0,0,0,0,0,1,0,0, ALUOP_BRANCH);

    opcode = OP_JAL;
    check_signals("JAL", 1,0,0,0,0,0,1,0, ALUOP_ADD);

    opcode = OP_JALR;
    check_signals("JALR", 1,0,0,0,1,0,1,1, ALUOP_ADD);

    opcode = OP_LUI;
    check_signals("LUI", 1,0,0,0,1,0,0,0, ALUOP_ADD);


    opcode = OP_AUIPC;
    check_signals("AUIPC", 1,0,0,0,1,0,0,0, ALUOP_ADD);

    opcode = 7'b1111111;
    check_signals("DEFAULT", 0,0,0,0,0,0,0,0, ALUOP_ADD);

    $display("Control_Unit testbench finished");
    $finish;
end
endmodule
