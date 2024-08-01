`timescale 1ns / 1ps

module RoutingLogic #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter NUM_PORTS = 4
)(
    input wire clk,
    input wire reset,
    input wire [NUM_PORTS*DATA_WIDTH-1:0] in_data,
    input wire [NUM_PORTS-1:0] in_valid,
    output wire [NUM_PORTS*DATA_WIDTH-1:0] out_data,
    output wire [NUM_PORTS-1:0] out_valid
);

    // Simple round-robin routing logic for demonstration
    reg [DATA_WIDTH-1:0] out_data_reg [NUM_PORTS-1:0];
    reg out_valid_reg [NUM_PORTS-1:0];

    integer j;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (j = 0; j < NUM_PORTS; j = j + 1) begin
                out_data_reg[j] <= 0;
                out_valid_reg[j] <= 0;
            end
        end else begin
            for (j = 0; j < NUM_PORTS; j = j + 1) begin
                out_data_reg[j] <= in_data[j*DATA_WIDTH +: DATA_WIDTH];
                out_valid_reg[j] <= in_valid[j];
            end
        end
    end

    genvar i;
    generate
        for (i = 0; i < NUM_PORTS; i = i + 1) begin : output_assign
            assign out_data[i*DATA_WIDTH +: DATA_WIDTH] = out_data_reg[i];
            assign out_valid[i] = out_valid_reg[i];
        end
    endgenerate

endmodule
