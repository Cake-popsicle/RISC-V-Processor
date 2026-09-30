`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2026 09:53:54
// Design Name: 
// Module Name: MUX_TB
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


module MUX_TB;

logic [31:0] a;
logic [31:0] b;
logic sel;
logic [31:0] c;
    
MUX dut (.*);

task automatic check_mux(input string test_name, input logic [31:0] expected);
        #1;
        if (c !== expected)
            $error("FAIL: %s expected %h got %h", test_name, expected, c);
        else
            $display("PASS: %s", test_name);
    endtask

    initial begin
        $display("Starting MUX testbench");

        a = 32'hAAAA_AAAA;
        b = 32'h5555_5555;

        sel = 1'b0;
        check_mux("SEL=0 chooses a", 32'hAAAA_AAAA);

        sel = 1'b1;
        check_mux("SEL=1 chooses b", 32'h5555_5555);

        a = 32'h1234_5678;
        b = 32'hDEAD_BEEF;

        sel = 1'b0;
        check_mux("Updated inputs with SEL=0", 32'h1234_5678);

        sel = 1'b1;
        check_mux("Updated inputs with SEL=1", 32'hDEAD_BEEF);

        $display("MUX testbench finished");
        $finish;
    end

endmodule
