`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2026 10:58:05
// Design Name: 
// Module Name: Data_Memory_TB
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


module Data_Memory_TB;
logic clk;
logic reset;
logic mem_read;
logic mem_write;
logic [31:0] address;
logic [31:0] write_data;
logic [31:0] read_data;

Data_Memory dut (.*);

always #1 clk = ~clk;

    task automatic check_signals(input string name, input logic [31:0] actual, input logic [31:0] expected);
        if (actual !== expected)
            $error("FAIL: %s expected %h got %h", name, expected, actual);
        else
            $display("PASS: %s", name);
    endtask

    initial begin
        $display("Starting Data_Memory testbench");
        clk = 0;
        reset = 1;
        mem_read = 0;
        mem_write = 0;
        address = 0;
        write_data = 32'b0;

        @(posedge clk);
        #0.1;
        reset = 1'b0;

        // Write to 0x0000_0008
        address = 32'h0000_0008;
        write_data = 32'h1234_5678;
        mem_write = 1;
        @(posedge clk);
        #0.1;
        mem_write = 0;

        // Read back the written word
        mem_read = 1;
        #0.1;
        check_signals("Read back addr 0x8", read_data, 32'h1234_5678);

        // When mem_read is low, read_data should be zero
        mem_read = 0;
        #0.1;
        check_signals("Read disabled outputs zero", read_data, 32'h0000_0000);

        // Write and read another address
        address = 32'h0000_0010;
        write_data = 32'hABBA_ACDC;
        mem_write = 1;
        @(posedge clk);
        #0.1;
        mem_write = 0;

        mem_read = 1;
        #0.1;
        check_signals("Read back addr 0x10", read_data, 32'hABBA_ACDC);

        // Reset should clear all memory locations
        reset = 1;
        #0.1;
        reset = 0;

        address = 32'h0000_0008;
        mem_read = 1;
        #0.1;
        check_signals("Reset clears addr 0x8", read_data, 32'h0000_0000);

        address = 32'h0000_0010;
        #0.1;
        check_signals("Reset clears addr 0x10", read_data, 32'h0000_0000);

        $display("Data_Memory testbench finished");
        $finish;
    end
endmodule
