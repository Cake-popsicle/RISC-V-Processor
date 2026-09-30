`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:35:25
// Design Name: 
// Module Name: Instruction_Memory
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

// Instruction memory returns the instruction stored in a given address space

module Instruction_Memory(
    input logic [31:0] address,
    output logic [31:0] instruction
    );
    
    logic [31:0] memory [0:255];
    
    initial begin
        $readmemh("program.mem", memory );
    end
    // Divide by 4 for the number of bytes in an instruction
    assign instruction = memory[address[31:2]];
endmodule
