`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2026 11:38:20
// Design Name: 
// Module Name: Top_TB
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


module Top_TB;
logic clk;
logic reset;
int i;

logic [31:0] pc;
logic [31:0] instruction;
logic [31:0] alu_result;
Top dut (
    .clk(clk),
    .reset(reset),
    .debug_pc(pc),
    .debug_instruction(instruction),
    .debug_alu_result(alu_result)
);

// 1ns 
always #1 clk = ~clk;

// Print all registers
task automatic display_registers(input string mem_file);
    begin
        $display("Register dump after [%s]:", mem_file);
        for (i = 0; i < 32; i++) begin
            $display("  x%0d = 0x%08h (%0d)", i, dut.regfile_inst.registers[i], $signed(dut.regfile_inst.registers[i]));
        end
    end
endtask
    
// Store the data from a specified mem file into the instruction memory
task automatic load_instruction_memory(input string mem_file);
    begin
        for (i = 0; i < 256; i++) begin
            dut.im_inst.memory[i] = 32'h00000013; // NOP (addi x0, x0, 0)
        end

        $display("Loading test program: %s", mem_file);
        $readmemh(mem_file, dut.im_inst.memory);
    end
endtask

// Run the program in a specified mem file
task automatic run_program(input string mem_file, input int max_cycles);
    int cycle;
    begin
        load_instruction_memory(mem_file);

        reset = 1;
        @(posedge clk);
        @(posedge clk);
        reset = 0;

        for (cycle = 0; cycle < max_cycles; cycle++) begin
            @(posedge clk);

            if (dut.regfile_inst.registers[31] == 32'd1) begin
                $display("PASS [%s] in %0d cycles", mem_file, cycle + 1);
                display_registers(mem_file);
                return;
            end

            if (dut.regfile_inst.registers[31] == 32'hFFFF_FFFF) begin
                $display("FAIL [%s] hit fail marker in x31", mem_file);
                display_registers(mem_file);
                return;
            end
        end

        $display("TIMEOUT [%s] did not reach pass/fail marker in %0d cycles", mem_file, max_cycles);
        display_registers(mem_file);
    end
endtask

initial begin
    string mem_files [0:6];
    
    clk = 0;
    reset = 1;
    mem_files[0] = "SIMPLE_PROGRAM.mem";
    mem_files[1] = "RTYPE_TEST.mem";
    mem_files[2] = "ITYPE_TEST.mem";
    mem_files[3] = "BRANCHES_TEST.mem";
    mem_files[4] = "JUMPS_TEST.mem";
    mem_files[5] = "UPPER_IMM_TEST.mem";
    mem_files[6] = "MEMORY_TEST.mem";

    foreach (mem_files[idx]) begin
        run_program(mem_files[idx], 300);
    end

    $display("Completed sequential execution of all test programs.");
    $finish;
end

initial begin
    $monitor(
        "time=%0t pc=%h instr=%h alu_result=%h wb=%h",
        $time,
        dut.current_pc,
        dut.instruction,
        dut.ALU_result,
        dut.write_back_data
    );
end

endmodule
