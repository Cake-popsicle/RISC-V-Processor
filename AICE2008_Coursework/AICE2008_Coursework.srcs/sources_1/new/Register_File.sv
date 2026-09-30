`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:35:25
// Design Name: 
// Module Name: Register_File
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

// Register file handles reading and writing data to registers, register 0 is hardcoded to return 0. 
// Reset high will cause the data in all registers to be set to 0.
// Reading is handled asynchronously while writing is on the rising edge of the clock

module Register_File(
    input logic clk, reset, reg_write,
    input logic [4:0] rs1, rs2, rd,
    input logic [31:0] write_data,
    output logic [31:0] read_data1, read_data2
    );
    
    // Stores 32 bits of data for the 32 registers
    logic [31:0] registers [31:0];
    
    always_comb begin
        if(rs1 != 5'b0) 
            read_data1 = registers[rs1];
        else
            read_data1 = 32'b0;
        if(rs2 != 5'b0) 
            read_data2 = registers[rs2];
        else
            read_data2 = 32'b0;
    end
    
    always_ff @(posedge clk, posedge reset) begin
    
        if (reset) begin
            // Reset all registers to zero
            for (int i = 1; i < 32; i++) begin
                registers[i] <= 32'b0;
            end
        end
        else if(reg_write && rd != 5'b0) begin
            registers[rd] <= write_data;
        end
        
    end
endmodule
