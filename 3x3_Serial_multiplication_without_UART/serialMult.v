module serial_matrix_multiplication (
    input clk,
    input rst,
    input [7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8,  // Input matrix A
    input [7:0] b0, b1, b2, b3, b4, b5, b6, b7, b8,  // Input matrix B
    output reg [15:0] c0, c1, c2, c3, c4, c5, c6, c7, c8, // Output matrix C
    output reg done,         // Done signal when multiplication is complete
    output reg [15:0] cycle_count  // Total clock cycles
);

    // Internal state variables
    reg [3:0] state; // State for FSM
    reg [15:0] count; // Step counter for the multiplication process
    reg [15:0] sum;  // Sum for partial calculation
    reg [15:0] mul_result; // Store the result of each multiplication step

    // FSM states
    parameter IDLE = 4'd0,
              MULTIPLY = 4'd1,
              DONE = 4'd2;

    // FSM and calculations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the state, output, and cycle count
            state <= IDLE;
            count <= 0;
            done <= 0;
            cycle_count <= 0;
            c0 <= 0; c1 <= 0; c2 <= 0;
            c3 <= 0; c4 <= 0; c5 <= 0;
            c6 <= 0; c7 <= 0; c8 <= 0;
            sum <= 0;
            mul_result <= 0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 0; // Clear done signal
                    cycle_count <= 0; // Reset cycle counter
                    state <= MULTIPLY; // Move to multiply state
                end

                MULTIPLY: begin
                    case(count)
                        // First element c0
                        0: begin
                            mul_result <= a0 * b0;   // c0: a0 * b0
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        1: begin
                            mul_result <= mul_result + (a1 * b3);   // c0: sum + (a1 * b3)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        2: begin
                            mul_result <= mul_result + (a2 * b6);   // c0: sum + (a2 * b6)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        3: begin
                            c0 <= mul_result;        // Store c0
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Second element c1
                        4: begin
                            mul_result <= a0 * b1;   // c1: a0 * b1
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        5: begin
                            mul_result <= mul_result + (a1 * b4);   // c1: sum + (a1 * b4)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        6: begin
                            mul_result <= mul_result + (a2 * b7);   // c1: sum + (a2 * b7)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        7: begin
                            c1 <= mul_result;        // Store c1
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Third element c2
                        8: begin
                            mul_result <= a0 * b2;   // c2: a0 * b2
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        9: begin
                            mul_result <= mul_result + (a1 * b5);   // c2: sum + (a1 * b5)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        10: begin
                            mul_result <= mul_result + (a2 * b8);   // c2: sum + (a2 * b8)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        11: begin
                            c2 <= mul_result;        // Store c2
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Fourth element c3
                        12: begin
                            mul_result <= a3 * b0;   // c3: a3 * b0
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        13: begin
                            mul_result <= mul_result + (a4 * b3);   // c3: sum + (a4 * b3)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        14: begin
                            mul_result <= mul_result + (a5 * b6);   // c3: sum + (a5 * b6)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        15: begin
                            c3 <= mul_result;        // Store c3
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Fifth element c4
                        16: begin
                            mul_result <= a3 * b1;   // c4: a3 * b1
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        17: begin
                            mul_result <= mul_result + (a4 * b4);   // c4: sum + (a4 * b4)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        18: begin
                            mul_result <= mul_result + (a5 * b7);   // c4: sum + (a5 * b7)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        19: begin
                            c4 <= mul_result;        // Store c4
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Sixth element c5
                        20: begin
                            mul_result <= a3 * b2;   // c5: a3 * b2
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        21: begin
                            mul_result <= mul_result + (a4 * b5);   // c5: sum + (a4 * b5)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        22: begin
                            mul_result <= mul_result + (a5 * b8);   // c5: sum + (a5 * b8)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        23: begin
                            c5 <= mul_result;        // Store c5
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Seventh element c6
                        24: begin
                            mul_result <= a6 * b0;   // c6: a6 * b0
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        25: begin
                            mul_result <= mul_result + (a7 * b3);   // c6: sum + (a7 * b3)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        26: begin
                            mul_result <= mul_result + (a8 * b6);   // c6: sum + (a8 * b6)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        27: begin
                            c6 <= mul_result;        // Store c6
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Eighth element c7
                        28: begin
                            mul_result <= a6 * b1;   // c7: a6 * b1
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        29: begin
                            mul_result <= mul_result + (a7 * b4);   // c7: sum + (a7 * b4)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        30: begin
                            mul_result <= mul_result + (a8 * b7);   // c7: sum + (a8 * b7)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        31: begin
                            c7 <= mul_result;        // Store c7
                            mul_result <= 0;         // Reset mul_result
                        end

                        // Ninth element c8
                        32: begin
                            mul_result <= a6 * b2;   // c8: a6 * b2
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        33: begin
                            mul_result <= mul_result + (a7 * b5);   // c8: sum + (a7 * b5)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        34: begin
                            mul_result <= mul_result + (a8 * b8);   // c8: sum + (a8 * b8)
                            cycle_count <= cycle_count + 1; // Increment cycle count
                        end
                        35: begin
                            c8 <= mul_result;        // Store c8
                            done <= 1;        // Set done flag
                        end
                    endcase

                    // Update count for next multiplication step
                    count <= count + 1;

                    // If all elements are calculated, move to DONE state
                    if (count == 35)
                        state <= DONE;
                end

                DONE: begin
                    // Hold done signal high
                    done <= 1;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
