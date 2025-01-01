module tb_matrix_mult;

    // Testbench signals
    reg clk;
    reg rst;
    reg [7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8;  // Input matrix A (3x3)
    reg [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8;  // Input matrix B (3x3)
    wire [7:0] c0, c1, c2, c3, c4, c5, c6, c7, c8; // Output matrix C (3x3)
    wire done;  // New done signal from matrix_mult module

    // Cycle counter
    integer cycle_count;
    integer finish_time;

    // Instantiate the matrix_mult module
    matrix_mult uut (
        .clk(clk),
        .rst(rst),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .a5(a5), .a6(a6), .a7(a7), .a8(a8),
        .b0(b0), .b1(b1), .b2(b2), .b3(b3), .b4(b4), .b5(b5), .b6(b6), .b7(b7), .b8(b8),
        .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4), .c5(c5), .c6(c6), .c7(c7), .c8(c8),
        .done(done)  // Connect done signal
    );

    // Clock generation (50 MHz clock)
    always begin
        #10 clk = ~clk;  // 50 MHz clock, period = 20 ns
    end

    // Cycle count monitor
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cycle_count <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
        end
    end

    // Stimulus block
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        a0 = 8'd1; a1 = 8'd2; a2 = 8'd3;
        a3 = 8'd4; a4 = 8'd5; a5 = 8'd6;
        a6 = 8'd7; a7 = 8'd8; a8 = 8'd9;

        b0 = 8'd9; b1 = 8'd8; b2 = 8'd7;
        b3 = 8'd6; b4 = 8'd5; b5 = 8'd4;
        b6 = 8'd3; b7 = 8'd2; b8 = 8'd1;

        cycle_count = 0;  // Initialize cycle counter
        finish_time = 0;  // Time when computation finishes

        // Apply reset
        rst = 1;
        #20;
        rst = 0;

        // Wait for the done signal to assert (multiplication complete)
        wait(done == 1);

        // Once result is ready, store the finish time (clock cycle number)
        finish_time = cycle_count;

        // Wait some time for the result to stabilize
        #100;

        // Display results
        $display("Matrix A:");
        $display("%d %d %d", a0, a1, a2);
        $display("%d %d %d", a3, a4, a5);
        $display("%d %d %d", a6, a7, a8);
        
        $display("Matrix B:");
        $display("%d %d %d", b0, b1, b2);
        $display("%d %d %d", b3, b4, b5);
        $display("%d %d %d", b6, b7, b8);
        
        $display("Matrix C (Result):");
        $display("%d %d %d", c0, c1, c2);
        $display("%d %d %d", c3, c4, c5);
        $display("%d %d %d", c6, c7, c8);

        // Print number of cycles taken
        $display("Matrix multiplication completed in %d clock cycles", finish_time);

        // Finish simulation
        //$finish;
    end

endmodule
