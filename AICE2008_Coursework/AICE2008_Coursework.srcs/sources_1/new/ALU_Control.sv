`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:45:15
// Design Name: 
// Module Name: ALU_Control
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

// ALU_Control finds the base function that the alu needs to perform a given instruction, it does this using the funct3 and 7 values, 
// as well as the ALU_op generated in Control_unit; it then outputs this as a 4 bit number which is sent to the ALU

import Definitions::*;
module ALU_Control(
input logic [1:0] ALU_op,
input logic [2:0] funct3,
input logic [6:0]funct7,
output logic [3:0] ALU_control
    );
    always_comb begin
        unique case (ALU_op)
            ALUOP_ADD: begin
                ALU_control = ALU_ADD;
            end
            ALUOP_BRANCH: begin
                case (funct3)
                    F3_BEQ: ALU_control = ALU_SUB;   // beq
                    F3_BNE: ALU_control = ALU_SUB;   // bne
                    F3_BLT: ALU_control = ALU_SLT;   // blt
                    F3_BGE: ALU_control = ALU_SLT;   // bge
                    F3_BLTU: ALU_control = ALU_SLTU;  // bltu
                    F3_BGEU: ALU_control = ALU_SLTU;  // bgeu
                    default: ALU_control = ALU_ADD;
                endcase
            end
            ALUOP_RTYPE: begin
                case (funct3)
                    F3_ADD_SUB: begin
                        if (funct7 == F7_SUB)
                            ALU_control = ALU_SUB;
                        else
                            ALU_control = ALU_ADD;
                    end
                    F3_AND: ALU_control = ALU_AND;
                    F3_OR: ALU_control = ALU_OR;
                    F3_XOR: ALU_control = ALU_XOR;
                    F3_SLT: ALU_control = ALU_SLT;
                    F3_SLTU: ALU_control = ALU_SLTU;
                    F3_SLL: ALU_control = ALU_SLL;
                    F3_SRL_SRA : begin
                        if (funct7 == F7_SRA)
                            ALU_control = ALU_SRA;
                        else
                            ALU_control = ALU_SRL;
                    end
                    default: ALU_control = ALU_ADD;
                endcase 
            end
            ALUOP_ITYPE: begin
                case (funct3)
                    F3_ADD_SUB: ALU_control = ALU_ADD;   // addi
                    F3_AND: ALU_control = ALU_AND;   // andi
                    F3_OR: ALU_control = ALU_OR;    // ori
                    F3_XOR: ALU_control = ALU_XOR;   // xori
                    F3_SLT: ALU_control = ALU_SLT;   // slti
                    F3_SLTU: ALU_control = ALU_SLTU;  // sltiu
                    F3_SLL: ALU_control = ALU_SLL;   // slli
                    F3_BGE: begin
                        if (funct7 == F7_SRA)
                            ALU_control = ALU_SRA;   // srai
                        else
                            ALU_control = ALU_SRL;   // srli
                    end
                    default: ALU_control = ALU_ADD;
                endcase 
            end
            default: begin
                ALU_control = ALU_ADD;
            end
        endcase
    end
endmodule
