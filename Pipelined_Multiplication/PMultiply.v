module pipelined_matrix_mult (
    input clk,
    input rst,
    input [7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8,  // Input matrix A (3x3)
    input [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8,  // Input matrix B (3x3)
    output reg [7:0] c0, c1, c2, c3, c4, c5, c6, c7, c8,  // Output matrix C (3x3)
    output reg done  // Output to indicate computation completion
);

    reg [15:0] mul1, mul2, mul3, mul4, mul5, mul6;
    reg [15:0] mul7, mul8, mul9, mul10, mul11, mul12;
    reg [15:0] mul13, mul14, mul15, mul16, mul17, mul18;
    reg [15:0] mul19, mul20, mul21, mul22, mul23, mul24;
    reg [15:0] mul25, mul26, mul27;
    reg [1:0] stage; // Stage register for pipelining

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset outputs and intermediate registers
            c0 <= 8'b0; c1 <= 8'b0; c2 <= 8'b0;
            c3 <= 8'b0; c4 <= 8'b0; c5 <= 8'b0;
            c6 <= 8'b0; c7 <= 8'b0; c8 <= 8'b0;
            mul1 <= 16'b0; mul2 <= 16'b0; mul3 <= 16'b0; mul4 <= 16'b0;
            mul5 <= 16'b0; mul6 <= 16'b0; mul7 <= 16'b0; mul8 <= 16'b0; mul9 <= 16'b0;
            mul10 <= 16'b0; mul11 <= 16'b0; mul12 <= 16'b0;
            mul13 <= 16'b0; mul14 <= 16'b0; mul15 <= 16'b0;
            mul16 <= 16'b0; mul17 <= 16'b0; mul18 <= 16'b0;
            mul19 <= 16'b0; mul20 <= 16'b0; mul21 <= 16'b0;
            mul22 <= 16'b0; mul23 <= 16'b0; mul24 <= 16'b0;
            mul25 <= 16'b0; mul26 <= 16'b0; mul27 <= 16'b0;
            stage <= 0; // Reset stage
            done <= 0; // Reset done signal
        end else begin
            case (stage)
                2'b00: begin
                    // Stage 1: Multiply elements from A and B
                    mul1 <= a0 * b0;
                    mul2 <= a1 * b3;
                    mul3 <= a2 * b6;
                    mul4 <= a0 * b1;
                    mul5 <= a1 * b4;
                    mul6 <= a2 * b7;
                    mul7 <= a0 * b2;
                    mul8 <= a1 * b5;
                    mul9 <= a2 * b8;
                    mul10 <= a3 * b0;
                    mul11 <= a4 * b3;
                    mul12 <= a5 * b6;
                    mul13 <= a3 * b1;
                    mul14 <= a4 * b4;
                    mul15 <= a5 * b7;
                    mul16 <= a3 * b2;
                    mul17 <= a4 * b5;
                    mul18 <= a5 * b8;
                    mul19 <= a6 * b0;
                    mul20 <= a7 * b3;
                    mul21 <= a8 * b6;
                    mul22 <= a6 * b1;
                    mul23 <= a7 * b4;
                    mul24 <= a8 * b7;
                    mul25 <= a6 * b2;
                    mul26 <= a7 * b5;
                    mul27 <= a8 * b8;
                    
                    stage <= 2'b01; // Move to the next stage
                    done <= 0;  // Set done to 0, computation is not complete yet
                end

                2'b01: begin
                    // Stage 2: Add the partial products and compute the final result
                    c0 <= mul1 + mul2 + mul3;
                    c1 <= mul4 + mul5 + mul6;
                    c2 <= mul7 + mul8 + mul9;
                    c3 <= mul10 + mul11 + mul12;
                    c4 <= mul13 + mul14 + mul15;
                    c5 <= mul16 + mul17 + mul18;
                    c6 <= mul19 + mul20 + mul21;
                    c7 <= mul22 + mul23 + mul24;
                    c8 <= mul25 + mul26 + mul27;
                    
                    done <= 1;  // Indicate that computation is complete
                    stage <= 2'b00; // Reset to the initial state for the next computation
                end
            endcase
        end
    end

endmodule
