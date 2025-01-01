module test_serial_matrix_multiplication;

    reg clk, rst;
    reg [7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8;
    reg [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8;
    wire [15:0] c0, c1, c2, c3, c4, c5, c6, c7, c8;
    wire done;
    wire [15:0] cycle_count;

    // Instantiate the matrix multiplication module
    serial_matrix_multiplication uut (
        .clk(clk),
        .rst(rst),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .a5(a5), .a6(a6), .a7(a7), .a8(a8),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .b5(b5), .b6(b6), .b7(b7), .b8(b8),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4), .c5(c5), .c6(c6), .c7(c7), .c8(c8),
        .done(done),
        .cycle_count(cycle_count)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize inputs
        clk = 0; rst = 1;
        a0 = 1; a1 = 2; a2 = 3; a3 = 4; a4 = 5; a5 = 6; a6 = 7; a7 = 8; a8 = 9;
        b0 = 9; b1 = 8; b2 = 7; b3 = 6; b4 = 5; b5 = 4; b6 = 3; b7 = 2; b8 = 1;

        // Release reset
        #10 rst = 0;

        // Wait for done signal
        wait(done);

        // Display results
        $display("Matrix C (Result):");
        $display("C0 = %d, C1 = %d, C2 = %d", c0, c1, c2);
        $display("C3 = %d, C4 = %d, C5 = %d", c3, c4, c5);
        $display("C6 = %d, C7 = %d, C8 = %d", c6, c7, c8);
        $display("Clock cycles taken: %d", cycle_count);
        
       // $finish;
    end
endmodule
