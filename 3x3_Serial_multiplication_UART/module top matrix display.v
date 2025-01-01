module top_matrix_display (
    input clk,
    input rst,
    input [3:0] switches,  // Switches to select matrix index
    output [6:0] seg,      // 7-segment display segments a-g
    output dp,             // Decimal point
    output [3:0] an        // Digit enable
);

    // Matrix inputs (hardcoded for demonstration)
    wire [7:0] a0 = 8'd1, a1 = 8'd2, a2 = 8'd3,
               a3 = 8'd4, a4 = 8'd5, a5 = 8'd6,
               a6 = 8'd7, a7 = 8'd8, a8 = 8'd9;

    wire [7:0] b0 = 8'd9, b1 = 8'd8, b2 = 8'd7,
               b3 = 8'd6, b4 = 8'd5, b5 = 8'd4,
               b6 = 8'd3, b7 = 8'd2, b8 = 8'd1;

    // Matrix result outputs
    wire [7:0] c0, c1, c2, c3, c4, c5, c6, c7, c8;

    // Instantiate the matrix multiplication module
    serial_matrix_multiplication _mult (
        .clk(clk),
        .rst(rst),
        .a0(a0), .a1(a1), .a2(a2),
        .a3(a3), .a4(a4), .a5(a5),
        .a6(a6), .a7(a7), .a8(a8),
        .b0(b0), .b1(b1), .b2(b2),
        .b3(b3), .b4(b4), .b5(b5),
        .b6(b6), .b7(b7), .b8(b8),
        .c0(c0), .c1(c1), .c2(c2),
        .c3(c3), .c4(c4), .c5(c5),
        .c6(c6), .c7(c7), .c8(c8)
    );
