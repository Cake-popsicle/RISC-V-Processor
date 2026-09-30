`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:35:25
// Design Name: 
// Module Name: Immediate_Generator
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

// Immediate generator extracts the immedtiate values out of an instruction in order
// based on the type of instruction

import Definitions::*;
module Immediate_Generator(
input logic [31:0] instruction,
output logic [31:0] imm_out
    );
    logic [6:0] opcode;
    always_comb begin
        opcode = instruction[6:0];
        imm_out = 32'b0;
        unique case (opcode)
            OP_RTYPE: begin
                imm_out = 32'b0;
            end
            OP_IMM, OP_LOAD, OP_JALR: begin //I-TYPE
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            end
            OP_STORE: begin
                imm_out = {{20{instruction[31]}},instruction[31:25], instruction[11:7]};
            end
            OP_BRANCH: begin
                imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            OP_JAL: begin
                imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            OP_LUI, OP_AUIPC: begin
                imm_out = {instruction[31:12], 12'b0};
            end
            default: begin
                imm_out = 32'b0;
            end
        endcase
    end
    
endmodule
