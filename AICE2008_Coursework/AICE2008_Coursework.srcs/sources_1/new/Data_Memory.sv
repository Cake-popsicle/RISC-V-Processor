`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:37:48
// Design Name: 
// Module Name: Data_Memory
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
module Data_Memory(
input logic clk, reset, mem_read, mem_write,
input logic [31:0] address, write_data,
output logic [31:0] read_data
    );
    
    // Stores 32 bits of data for the 256 memory addresses
    logic [31:0] memory [255:0];

    always_comb begin
        if(mem_read) read_data = memory[address >> 2];
        else read_data = 32'b0;
    end

    always_ff @(posedge clk, posedge reset) begin
    
        if (reset) begin
            // Reset all memory adresses to zero
            for (int i = 0; i < 256; i++) begin
                memory[i] <= 32'b0;
            end
        end
        else if(mem_write) begin
            memory[address >> 2] <= write_data;
        end
        
    end
    
endmodule
