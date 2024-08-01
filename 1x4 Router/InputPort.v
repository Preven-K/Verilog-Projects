`timescale 1ns / 1ps

module InputPort #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire reset,
    input wire [ADDR_WIDTH-1:0] in_addr,
    input wire [DATA_WIDTH-1:0] in_data,
    input wire in_valid,
    output wire [DATA_WIDTH-1:0] out_data,
    output wire out_valid
);

    // For simplicity, directly pass the input data to the output
    assign out_data = in_data;
    assign out_valid = in_valid;

endmodule
