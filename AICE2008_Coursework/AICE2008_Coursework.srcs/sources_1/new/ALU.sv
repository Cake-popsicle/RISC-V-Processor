`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:37:48
// Design Name: 
// Module Name: ALU
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
module ALU(
input logic [31:0] A, B, 
input logic [3:0] ALU_control,
output logic [31:0] result
    );
    always_comb begin
        case(ALU_control)
            ALU_ADD: begin
                result = A + B;
            end
            ALU_SUB: begin
                result = A - B;
            end
            ALU_AND: begin
                result = A & B;
            end
            ALU_OR: begin
                result = A | B;
            end
            ALU_XOR: begin
                result = A ^ B;
            end
            ALU_SLL: begin
                result = A << B[4:0];
            end
            ALU_SRL: begin
                result = A >> B[4:0];
            end
            ALU_SRA: begin
                result = $signed(A) >>> B[4:0];
            end
            ALU_SLT: begin
                if($signed(A) < $signed(B)) result = 32'b1;
                else result = 32'b0;
            end
            ALU_SLTU: begin
                if(A < B) result = 32'b1;
                else result = 32'b0;
            end
            default: begin
                result = 32'b0;
            end
        endcase
        
    end

endmodule
