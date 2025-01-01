module tb_matrix_mult_10x10;
    reg clk, rst;
    reg [799:0] A, B;  // Flattened 10x10 matrices
    wire [799:0] C;    // Flattened output matrix
    wire done;

    matrix_mult_10x10 uut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .C(C),
        .done(done)
    );

    integer i, j;

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        A = 800'b0;
        B = 800'b0;

        // Reset
        #10 rst = 0;

        // Initialize A with values 1 to 100
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 10; j = j + 1) begin
                A[(i*10+j)*8 +: 8] = (i*10+j+1);  // Sequential values from 1 to 100
            end
        end

        // Initialize B as the identity matrix
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 10; j = j + 1) begin
                if (i == j)
                    B[(i*10+j)*8 +: 8] = 8'd1; // Diagonal elements = 1
                else
                    B[(i*10+j)*8 +: 8] = 8'd0; // Off-diagonal elements = 0
            end
        end

        // Wait for multiplication to complete
        #100;

        // Display the resulting matrix C
        $display("Resulting Matrix C:");
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 10; j = j + 1) begin
                $write("%d ", C[(i*10+j)*8 +: 8]);
            end
            $write("\n");
        end

        //$finish;
    end
endmodule
