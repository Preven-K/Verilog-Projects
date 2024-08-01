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
// Module Router 32bit
module Router32 (
    input wire clk,
    input wire reset,
    input wire [`NUM_PORTS*`ADDR_WIDTH-1:0] in_addr,
    input wire [`NUM_PORTS*`DATA_WIDTH-1:0] in_data,
    input wire [`NUM_PORTS-1:0] in_valid,
    output wire [`NUM_PORTS*`DATA_WIDTH-1:0] out_data,
    output wire [`NUM_PORTS-1:0] out_valid
);

    // Internal Signals
    reg [`DATA_WIDTH-1:0] out_data_reg [`NUM_PORTS-1:0];
    reg out_valid_reg [`NUM_PORTS-1:0];

    integer j;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (j = 0; j < `NUM_PORTS; j = j + 1) begin
                out_data_reg[j] <= 0;
                out_valid_reg[j] <= 0;
            end
        end else begin
            for (j = 0; j < `NUM_PORTS; j = j + 1) begin
                out_data_reg[j] <= in_data[j*`DATA_WIDTH +: `DATA_WIDTH];
                out_valid_reg[j] <= in_valid[j];
            end
        end
    end

    genvar i;
    generate
        for (i = 0; i < `NUM_PORTS; i = i + 1) begin : output_assign
            assign out_data[i*`DATA_WIDTH +: `DATA_WIDTH] = out_data_reg[i];
            assign out_valid[i] = out_valid_reg[i];
        end
    endgenerate

endmodule
