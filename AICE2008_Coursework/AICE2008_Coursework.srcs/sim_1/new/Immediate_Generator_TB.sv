`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2026 09:53:54
// Design Name: 
// Module Name: Immediate_Generator_TB
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

`timescale 1ns / 1ps

import Definitions::*;

module Immediate_Generator_TB;

logic [31:0] instruction;
logic [31:0] imm_out;

Immediate_Generator dut (.*);

task automatic check_signals(input string name, input logic [31:0] expected);
    #1;
    if (imm_out !== expected)
        $error("FAIL: %s expected %h got %h", name, expected, imm_out);
    else
        $display("PASS: %s", name);
endtask

initial begin
    $display("Starting Immediate_Generator testbench");

    instruction = 32'b0;
    instruction[6:0] = OP_RTYPE;
    check_signals("R-type", 32'h00000000);
     
    instruction = 32'b0;
    instruction[6:0] = OP_IMM;
    instruction[31:20] = 12'h00A;
    check_signals("I-type +10", 32'h0000000A);

    instruction = 32'b0;
    instruction[6:0] = OP_IMM;
    instruction[31:20] = 12'hFFF;
    check_signals("I-type -1", 32'hFFFF_FFFF);

    instruction = 32'b0;
    instruction[6:0] = OP_JALR;
    instruction[31:20] = 12'hFF8;
    check_signals("JALR -8", 32'hFFFF_FFF8);

    instruction = 32'b0;
    instruction[6:0] = OP_STORE;
    instruction[31:25] = 7'b0000001;
    instruction[11:7]  = 5'b01010;
    check_signals("STORE +42", 32'h0000002A);

    instruction = 32'b0;
    instruction[6:0] = OP_BRANCH;
    instruction[31]    = 1'b0;
    instruction[7]     = 1'b0;
    instruction[30:25] = 6'b000000;
    instruction[11:8]  = 4'b0100;
    check_signals("BRANCH +8", 32'h00000008);

   
    // JAL immediate +2048 (bit11 set)
    instruction = 32'b0;
    instruction[6:0] = OP_JAL;
    instruction[20] = 1'b1;
    check_signals("JAL +2048", 32'h00000800);

    instruction = 32'b0;
    instruction[6:0] = OP_LUI;
    instruction[31:12] = 20'h12345;
    check_signals("LUI", 32'h12345000);

    instruction = 32'b0;
    instruction[6:0] = OP_AUIPC;
    instruction[31:12] = 20'hABCDE;
    check_signals("AUIPC", 32'hABCDE000);

    // Testing invalid opcode
    instruction = 32'b0;
    instruction[6:0] = 7'b1111111;
    check_signals("Invalid opcode", 32'h00000000);

    $display("Immediate_Generator testbench finished");
    $finish;
end

endmodule