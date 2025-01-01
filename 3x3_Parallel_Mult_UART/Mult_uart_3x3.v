`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:58:55 12/26/2024 
// Design Name: 
// Module Name:    Mult_uart_3x3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
module Mult_uart_3x3#(
    parameter CLOCK_RATE = 100000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rx,
    input wire rxEn,
    output wire [7:0] out,
    output wire rxDone,
    output wire rxBusy,
    output wire rxErr,
    output wire tx,
    input wire txEn,
    output wire txDone,
    output wire txBusy,
    output reg [7:0] display
);
    wire rxClk, txClk;
    reg [7:0] in = 8'd0;
    reg txStart;
    reg [7:0] matrix_A [0:8];
    reg [7:0] matrix_B [0:8];
    reg [15:0] matrix_R [0:8];
    reg [8:0] index = 0;
    reg [7:0] received_value;
    reg [1:0] state = 2'd0;
    reg [32:0] delay_counter = 0;
    reg [8:0] tx_count = 0;  // New counter for transmission
    
    reg prev_rxDone = 0;
    always @(posedge clk) begin
        prev_rxDone <= rxDone;
    end
    wire rxDoneEdge = rxDone & ~prev_rxDone; //finding the rxDone edge

    BaudRateGenerator #(
        .CLOCK_RATE(CLOCK_RATE),
        .BAUD_RATE(BAUD_RATE)
    ) generatorInst (
        .clk(clk),
        .rxClk(rxClk),
        .txClk(txClk)
    );

    Uart8Receiver rxInst (
        .clk(rxClk),
        .en(1'b1),
        .in(rx),
        .out(out),
        .done(rxDone),
        .busy(rxBusy),
        .err(rxErr)
    );
 
    Uart8Transmitter txInst (
        .clk(txClk),
        .en(txEn),
        .start(txStart),
        .in(in),
        .out(tx),
        .done(txDone),
        .busy(txBusy)
    );


    always @(posedge clk) begin
        case (state)
            2'd0: begin
                txStart <= 1'b0;  // Reset txStart
                if (rxDoneEdge) begin
                    received_value <= out;
                    if (index < 9) begin
                        matrix_A[index] <= out;
                        display <= out;
                    end else if (index < 18) begin
                        matrix_B[index - 9] <= out;
                        display<= out;
                    end
                    index <= index + 1;
                    if (index == 17) begin 
                        state <= 2'd1;
                        tx_count <= 0;  // Reset transmission counter
                    end
                end
            end
            
            2'd1: begin
        matrix_R[0] <= matrix_A[0] * matrix_B[0] + matrix_A[1] * matrix_B[3] + matrix_A[2] * matrix_B[6];
        matrix_R[1] <= matrix_A[0] * matrix_B[1] + matrix_A[1] * matrix_B[4] + matrix_A[2] * matrix_B[7];
        matrix_R[2] <= matrix_A[0] * matrix_B[2] + matrix_A[1] * matrix_B[5] + matrix_A[2] * matrix_B[8];
        
        matrix_R[3] <= matrix_A[3] * matrix_B[0] + matrix_A[4] * matrix_B[3] + matrix_A[5] * matrix_B[6];
        matrix_R[4] <= matrix_A[3] * matrix_B[1] + matrix_A[4] * matrix_B[4] + matrix_A[5] * matrix_B[7];
        matrix_R[5] <= matrix_A[3] * matrix_B[2] + matrix_A[4] * matrix_B[5] + matrix_A[5] * matrix_B[8];
        
        matrix_R[6] <= matrix_A[6] * matrix_B[0] + matrix_A[7] * matrix_B[3] + matrix_A[8] * matrix_B[6];
        matrix_R[7] <= matrix_A[6] * matrix_B[1] + matrix_A[7] * matrix_B[4] + matrix_A[8] * matrix_B[7];
        matrix_R[8] <= matrix_A[6] * matrix_B[2] + matrix_A[7] * matrix_B[5] + matrix_A[8] * matrix_B[8];
   
					 
					 state <= 2'd2;
                delay_counter <= 32'd12500; // giving a small delay before transmitting the result.
            end
            
            2'd2: begin
                if (delay_counter > 0) begin
                    delay_counter <= delay_counter - 1;
                    txStart <= 1'b0;
                end else if (tx_count < 9) begin  // Only transmit 9 values
                    if (!txBusy) begin
                        in <= matrix_R[tx_count];
                        txStart <= 1'b1;
                        if (txDone) begin
                            tx_count <= tx_count + 1;
                            delay_counter <= 32'd12500; // We put small delay for better transmitting the results.
                            txStart <= 1'b0;
                        end
                    end
                end else begin
                    state <= 2'd0;
                    index <= 0;
                    tx_count <= 0;
                    txStart <= 1'b0;
                end
            end
        endcase
    end
	 

endmodule


