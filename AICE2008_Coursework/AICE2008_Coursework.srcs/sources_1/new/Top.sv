`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:35:25
// Design Name: 
// Module Name: Top
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

// Top handles the glue logic of the CPU and instantiates all other modules in the project

import Definitions::*;
module Top(
    input logic clk,
    input logic reset,
    output logic [31:0] debug_pc,
    output logic [31:0] debug_instruction,
    output logic [31:0] debug_alu_result
    );
    
    // PC signals
    logic [31:0] current_pc;
    logic [31:0] next_pc;
    logic [31:0] pc_plus_4;
    logic [31:0] branch_target;
    logic [31:0] jalr_target;

    // Instruction fields
    logic [31:0] instruction;
    logic [6:0]  opcode;
    logic [4:0]  rd;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [2:0]  funct3;
    logic [6:0]  funct7;

    // Register file signals
    logic [31:0] reg_data1;
    logic [31:0] reg_data2;
    logic [31:0] write_back_data;

    // Immediate
    logic [31:0] immediate;

    // ALU signals
    logic [31:0] ALU_input_a;
    logic [31:0] ALU_input_b;
    logic [31:0] ALU_result;

    // Memory signal
    logic [31:0] mem_read_data;

    // Control signals
    logic reg_write;
    logic mem_read;
    logic mem_write;
    logic ALU_src;
    logic branch;
    logic branch_taken;
    logic jump;
    logic mem_to_reg;
    logic jalr;
    logic [3:0]  ALU_control;
    logic [1:0] ALU_op;
    
    // Derived constants
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];
    
    // Adders
    assign pc_plus_4 = current_pc + 32'd4;
    assign branch_target = current_pc + immediate;
    
    assign debug_instruction = instruction;
    assign debug_pc = current_pc;
    assign debug_alu_result = ALU_result;
    
    
    // Branch condition comparator
    always_comb begin
        branch_taken = 1'b0;
        if (branch) begin
            unique case (funct3)
                F3_BEQ:  branch_taken = (reg_data1 == reg_data2);
                F3_BNE:  branch_taken = (reg_data1 != reg_data2);
                F3_BLT:  branch_taken = ($signed(reg_data1) < $signed(reg_data2));
                F3_BGE:  branch_taken = ($signed(reg_data1) >= $signed(reg_data2));
                F3_BLTU: branch_taken = (reg_data1 < reg_data2);
                F3_BGEU: branch_taken = (reg_data1 >= reg_data2);
                default: branch_taken = 1'b0;
            endcase
        end
    end

    ////////////////////////////// MUXES //////////////////////////////

    // Next PC selection mux
    always_comb begin
        if (jump && jalr)
            next_pc = {ALU_result[31:1], 1'b0};
        else if (jump || branch_taken)
            next_pc = branch_target;
        else
            next_pc = pc_plus_4;
    end
    

    // Write back data selection mux
    always_comb begin
        if (opcode == OP_JAL || opcode == OP_JALR)
            write_back_data = pc_plus_4;
        else if (opcode == OP_LUI)
            write_back_data = immediate;
        else if (mem_to_reg)
            write_back_data = mem_read_data;
        else
            write_back_data = ALU_result;
    end
    
    
    // ALU parameter a selection mux
    always_comb begin
        if (opcode == OP_AUIPC)
            ALU_input_a = current_pc;
        else if (opcode == OP_LUI)
            ALU_input_a = 32'b0;
        else
            ALU_input_a = reg_data1;
    end    
        
        
    // ALU parameter b selection mux
    always_comb begin
        if (ALU_src)
            ALU_input_b = immediate;
        else
            ALU_input_b = reg_data2;
    end
    
    
    ////////////////////////////// Module instantiations //////////////////////////////
    Program_Counter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(current_pc)
    );
    
    Instruction_Memory im_inst (
        .address(current_pc),
        .instruction(instruction)
    );
    
    Control_Unit control_inst (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .ALU_src(ALU_src),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .ALU_op(ALU_op)
    );
    
    ALU_Control aluc_inst (
        .ALU_op(ALU_op),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_control(ALU_control)
    );
    
    Register_File regfile_inst (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .reg_write(reg_write),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );
    
    Immediate_Generator ig_inst (
        .instruction(instruction),
        .imm_out(immediate)
    );
    
    ALU alu_inst (
        .A(ALU_input_a),
        .B(ALU_input_b),
        .ALU_control(ALU_control),
        .result(ALU_result)
    );
    
    Data_Memory dm_inst (
        .clk(clk),
        .reset(reset),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(ALU_result),
        .write_data(reg_data2),
        .read_data(mem_read_data)
    );
  
endmodule
