`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2026 20:41:38
// Design Name: 
// Module Name: MUX
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


module MUX(
    input logic [31:0] a, b,
    input logic sel,
    output logic [31:0] c
    );
      
    always_comb begin
        if(sel) begin
            c = b;
        end
        else begin
            c = a;
        end
    end
    
endmodule
