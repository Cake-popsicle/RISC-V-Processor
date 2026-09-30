`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:37:48
// Design Name: 
// Module Name: Definitions
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


package Definitions;

  // Opcodes (RV32I)
  parameter logic [6:0] OP_RTYPE = 7'b0110011;
  parameter logic [6:0] OP_IMM = 7'b0010011;
  parameter logic [6:0] OP_LOAD = 7'b0000011;
  parameter logic [6:0] OP_STORE = 7'b0100011;
  parameter logic [6:0] OP_BRANCH = 7'b1100011;
  parameter logic [6:0] OP_JAL  = 7'b1101111;
  parameter logic [6:0] OP_JALR = 7'b1100111;
  parameter logic [6:0] OP_LUI  = 7'b0110111;
  parameter logic [6:0] OP_AUIPC= 7'b0010111;

  // funct3 codes
  parameter logic [2:0] F3_ADD_SUB = 3'b000;
  parameter logic [2:0] F3_LW_SW   = 3'b010;
  parameter logic [2:0] F3_AND  = 3'b111;
  parameter logic [2:0] F3_OR   = 3'b110;
  parameter logic [2:0] F3_XOR  = 3'b100;
  parameter logic [2:0] F3_SLT  = 3'b010;
  parameter logic [2:0] F3_SLTU = 3'b011;
  parameter logic [2:0] F3_SLL  = 3'b001;
  parameter logic [2:0] F3_SRL_SRA = 3'b101;
  parameter logic [2:0] F3_BEQ     = 3'b000;
  parameter logic [2:0] F3_BNE  = 3'b001;
  parameter logic [2:0] F3_BLT  = 3'b100;
  parameter logic [2:0] F3_BGE  = 3'b101;
  parameter logic [2:0] F3_BLTU = 3'b110;
  parameter logic [2:0] F3_BGEU = 3'b111;
  parameter logic [2:0] F3_SRAI  = 3'b101;

  // funct7 codes (for R-type distinction)
  parameter logic [6:0] F7_ADD = 7'b0000000;
  parameter logic [6:0] F7_SUB = 7'b0100000;
  parameter logic [6:0] F7_SRA = 7'b0100000;

  // ALU internal op codes
    parameter logic [3:0] ALU_ADD = 4'b0000;
    parameter logic [3:0] ALU_SUB = 4'b0001;
    parameter logic [3:0] ALU_AND = 4'b0010;
    parameter logic [3:0] ALU_OR  = 4'b0011;
    parameter logic [3:0] ALU_XOR  = 4'b0100;
    parameter logic [3:0] ALU_SLL  = 4'b0101;
    parameter logic [3:0] ALU_SRL  = 4'b0110;
    parameter logic [3:0] ALU_SRA  = 4'b0111;
    parameter logic [3:0] ALU_SLT  = 4'b1000;
    parameter logic [3:0] ALU_SLTU  = 4'b1001;
  // ALUOp (from Control Unit → ALU Control)
    parameter logic [1:0] ALUOP_ADD    = 2'b00;
    parameter logic [1:0] ALUOP_BRANCH = 2'b01;
    parameter logic [1:0] ALUOP_RTYPE  = 2'b10;
    parameter logic [1:0] ALUOP_ITYPE  = 2'b11;
    
endpackage
