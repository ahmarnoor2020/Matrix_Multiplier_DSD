module matrix_mult_10x10 (
    input clk,
    input rst,
    input [799:0] A,  // Flattened input matrix A (10x10, each element 8 bits)
    input [799:0] B,  // Flattened input matrix B (10x10, each element 8 bits)
    output reg [799:0] C, // Flattened output matrix C (10x10, each element 8 bits)
    output reg done  // Signal to indicate completion
);
    reg [7:0] a[0:9][0:9];
    reg [7:0] b[0:9][0:9];
    reg [15:0] temp; // Temporary 16-bit register for intermediate values
    integer i, j, k;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            C <= 800'b0;
            done <= 0;
        end else begin
            // Unpack flattened inputs A and B into 2D arrays
            for (i = 0; i < 10; i = i + 1) begin
                for (j = 0; j < 10; j = j + 1) begin
                    a[i][j] = A[(i*10+j)*8 +: 8];
                    b[i][j] = B[(i*10+j)*8 +: 8];
                end
            end

            // Perform matrix multiplication
            for (i = 0; i < 10; i = i + 1) begin
                for (j = 0; j < 10; j = j + 1) begin
                    temp = 0;
                    for (k = 0; k < 10; k = k + 1) begin
                        temp = temp + a[i][k] * b[k][j];
                    end
                    C[(i*10+j)*8 +: 8] = temp[7:0]; // Pack result back into flattened C
                end
            end
            done <= 1;
        end
    end
endmodule
