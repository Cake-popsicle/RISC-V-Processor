`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2026 09:53:54
// Design Name: 
// Module Name: Register_File_TB
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


module Register_File_TB;
logic clk;
logic reset;
logic reg_write;
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [31:0] write_data;
logic [31:0] read_data1;
logic [31:0] read_data2;
Register_File dut (.*);

always #1 clk = ~clk;

task automatic check_equal(input string name, input logic [31:0] actual, input logic [31:0] expected);
    if (actual !== expected)
        $error("FAIL: %s expected %h got %h", name, expected, actual);
    else
        $display("PASS: %s", name);
endtask

initial begin
    $display("Starting Register_File testbench");
    clk = 1'b0;
    reset = 1'b1;
    reg_write = 1'b0;
    rs1 = 5'd0;
    rs2 = 5'd0;
    rd = 5'd0;
    write_data = 32'd0;

    #1.2;
    reset = 1'b0;

    // Write x3
    rd = 5'd3;
    write_data = 32'h1234_5678;
    reg_write = 1'b1;
    @(posedge clk);
    #0.1;
    reg_write = 1'b0;

    rs1 = 5'd3;
    #0.1;
    check_equal("Read back x3", read_data1, 32'h1234_5678);

    // x0 should stay zero even with write enabled
    rd = 5'd0;
    write_data = 32'hFFFF_FFFF;
    reg_write = 1'b1;
    @(posedge clk);
    #0.1;
    reg_write = 1'b0;

    rs1 = 5'd0;
    #0.1;
    check_equal("x0 hardwired zero", read_data1, 32'h0000_0000);

    // Second register read
    rd = 5'd10;
    write_data = 32'hABBA_ACDC;
    reg_write = 1'b1;
    @(posedge clk);
    #0.1;
    reg_write = 1'b0;

    rs1 = 5'd3;
    rs2 = 5'd10;
    #0.1;
    check_equal("Read 1", read_data1, 32'h1234_5678);
    check_equal("Read 2", read_data2, 32'hABBA_ACDC);

    $display("Register_File testbench finished");
    $finish;
end
endmodule
