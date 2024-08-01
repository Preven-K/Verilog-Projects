`timescale 1ns / 1ps

// Define macros for module parameters
`define ADDR_WIDTH 32
`define DATA_WIDTH 32
`define NUM_PORTS 4

// Macro for Router32 module instantiation
`define INSTANTIATE_ROUTER32 \
    Router32 # ( \
        .ADDR_WIDTH(`ADDR_WIDTH), \
        .DATA_WIDTH(`DATA_WIDTH), \
        .NUM_PORTS(`NUM_PORTS) \
    ) uut ( \
        .clk(clk), \
        .reset(reset), \
        .in_addr(in_addr), \
        .in_data(in_data), \
        .in_valid(in_valid), \
        .out_data(out_data), \
        .out_valid(out_valid) \
    );

module Router32_tb;

    // Signals
    reg clk;
    reg reset;
    reg [`NUM_PORTS*`ADDR_WIDTH-1:0] in_addr;
    reg [`NUM_PORTS*`DATA_WIDTH-1:0] in_data;
    reg [`NUM_PORTS-1:0] in_valid;
    wire [`NUM_PORTS*`DATA_WIDTH-1:0] out_data;
    wire [`NUM_PORTS-1:0] out_valid;

    // Instantiate the Router32 module using macro
    `INSTANTIATE_ROUTER32

    // Clock Generation
    always begin
        #5 clk = ~clk; // 10ns period
    end

    // Testbench Procedure
    initial begin
        // Initialize Signals
        clk = 0;
        reset = 0;
        in_addr = 0;
        in_data = 0;
        in_valid = 0;

        // Apply Reset
        reset = 1;
        #10;
        reset = 0;

        // Test Single-Port Activity
        in_addr = {`NUM_PORTS{32'hAAAAAAAA}};  // Addresses set to 0xAAAAAAAA
        in_data = {`NUM_PORTS{32'hFFFFFFFF}};  // Data set to 0xFFFFFFFF
        in_valid = 4'b1000; // Only port 0 is valid
        
        #10; // Wait for one clock cycle

        // Check Outputs
        $display("Time: %0t | out_data: %h | out_valid: %b", $time, out_data, out_valid);
        
        // Change Inputs
        in_addr = {`NUM_PORTS{32'h55555555}};  // Addresses set to 0x55555555
        in_data = {`NUM_PORTS{32'h00000000}};  // Data set to 0x00000000
        in_valid = 4'b0100; // Only port 1 is valid
        
        #10; // Wait for one clock cycle

        // Check Outputs
        $display("Time: %0t | out_data: %h | out_valid: %b", $time, out_data, out_valid);
        
        // End Simulation
        #20;
        $stop;
    end

endmodule
