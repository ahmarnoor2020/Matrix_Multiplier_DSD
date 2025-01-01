module matrix_mult (
    input clk,
    input rst,
    input [7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8,  // Input matrix A (3x3)
    input [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8,  // Input matrix B (3x3)
    output reg [7:0] c0, c1, c2, c3, c4, c5, c6, c7, c8, // Output matrix C (3x3)
    output reg done  // New signal to indicate completion
);

    integer i, j, k;
    reg [15:0] sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset matrix C values to 0
            c0 <= 8'b0;
            c1 <= 8'b0;
            c2 <= 8'b0;
            c3 <= 8'b0;
            c4 <= 8'b0;
            c5 <= 8'b0;
            c6 <= 8'b0;
            c7 <= 8'b0;
            c8 <= 8'b0;
            done <= 0;  // Reset done signal
        end else begin
            // Perform matrix multiplication
            c0 <= (a0 * b0) + (a1 * b3) + (a2 * b6);
            c1 <= (a0 * b1) + (a1 * b4) + (a2 * b7);
            c2 <= (a0 * b2) + (a1 * b5) + (a2 * b8);
            c3 <= (a3 * b0) + (a4 * b3) + (a5 * b6);
            c4 <= (a3 * b1) + (a4 * b4) + (a5 * b7);
            c5 <= (a3 * b2) + (a4 * b5) + (a5 * b8);
            c6 <= (a6 * b0) + (a7 * b3) + (a8 * b6);
            c7 <= (a6 * b1) + (a7 * b4) + (a8 * b7);
            c8 <= (a6 * b2) + (a7 * b5) + (a8 * b8);
            
            done <= 1;  // Set done signal when multiplication is complete
        end
    end

endmodule
