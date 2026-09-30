`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:35:25
// Design Name: 
// Module Name: Program_Counter
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

// Program counter returns the address of the next address in the program at the positive clock edge, 
// while overriding the address to 0 when reset is high.
// Logic for the position of the next address is calculated in top

module Program_Counter(
    input logic clk,
    input logic reset,
    input logic [31:0] next_pc,
    output logic [31:0] pc
    );
    always_ff @(posedge clk, posedge reset) begin
        if(reset)
            pc <= 32'b0;
        else
            pc <= next_pc;
    end
    
endmodule
