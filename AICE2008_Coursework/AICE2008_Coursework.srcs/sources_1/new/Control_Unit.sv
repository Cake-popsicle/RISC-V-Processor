`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:35:25
// Design Name: 
// Module Name: Control_Unit
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

// The control unit determines the properties of the supplied function based on the instruction opcode
// and groups that share these properties.
// The properties are reg_write, mem_read, mem_write, mem_to_reg,
// ALU_src, branch, jump and jalr.
// It also gives a broad ALU operation that is further specified in the ALU_Control module

import Definitions::*;
module Control_Unit(
input logic [6:0] opcode,
output logic reg_write, mem_read, mem_write, mem_to_reg,
ALU_src, branch, jump, jalr,
output logic [1:0] ALU_op
    );
    
    always_comb begin
        reg_write  = 0;
        mem_read   = 0;
        mem_write  = 0;
        mem_to_reg = 0;
        ALU_src    = 0;
        branch     = 0;
        jump       = 0;
        jalr       = 0;
        ALU_op     = 2'b00;

        unique case (opcode)
            OP_RTYPE: begin
               reg_write = 1;
               ALU_op = ALUOP_RTYPE;
            end
            OP_IMM: begin
                reg_write = 1;
                ALU_src = 1;
                ALU_op = ALUOP_ITYPE;
            end
            OP_LOAD: begin
                reg_write  = 1;
                mem_read   = 1;
                mem_to_reg = 1;
                ALU_src    = 1;
                ALU_op = ALUOP_ADD;
            end
            OP_STORE: begin 
                mem_write = 1;
                ALU_src = 1;
                ALU_op = ALUOP_ADD;
            end
            OP_BRANCH: begin
                branch = 1;
                ALU_op = ALUOP_BRANCH;
            end
            OP_JAL: begin
                reg_write = 1;
                jump = 1;
            end
            OP_JALR: begin
                reg_write = 1;
                ALU_src = 1;
                jump = 1;
                jalr = 1;
                ALU_op = ALUOP_ADD;
            end
            OP_LUI: begin
                reg_write = 1;
                ALU_src = 1;
                ALU_op = ALUOP_ADD;
            end
            OP_AUIPC: begin
                reg_write = 1;
                ALU_src = 1;
                ALU_op = ALUOP_ADD;
            end
            default: begin
                
            end
        endcase
    end

endmodule
