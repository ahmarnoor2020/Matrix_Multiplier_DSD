module matrix_display_with_switches (
    input wire clk,
    input wire rst,
    input wire [3:0] switches,  // 4 switches for selecting the result index (0 to 8)
    input wire [71:0] matrix_result, // Flattened 3x3 matrix result (c0 to c8)
    output reg [6:0] seg,  // 7-segment segments a-g
    output reg dp,         // Decimal point
    output reg [3:0] an,   // Digit enable
    output reg led         // LED output
);

    reg [7:0] selected_result; // Selected result based on switch input
    reg [3:0] hundreds, tens, ones; // Hundreds, tens, and ones digits
    reg [19:0] refresh_counter;     // Counter for refresh rate
    reg [1:0] current_digit;        // 0 = ones, 1 = tens, 2 = hundreds

    // Decode the switch input to select the matrix result
    always @(*) begin
        case (switches)
            4'd0: selected_result = matrix_result[7:0];   // c0
            4'd1: selected_result = matrix_result[15:8];  // c1
            4'd2: selected_result = matrix_result[23:16]; // c2
            4'd3: selected_result = matrix_result[31:24]; // c3
            4'd4: selected_result = matrix_result[39:32]; // c4
            4'd5: selected_result = matrix_result[47:40]; // c5
            4'd6: selected_result = matrix_result[55:48]; // c6
            4'd7: selected_result = matrix_result[63:56]; // c7
            4'd8: selected_result = matrix_result[71:64]; // c8
            default: selected_result = 8'd0;             // Default to 0 if out of range
        endcase
    end

    // Decompose selected_result into hundreds, tens, and ones
    always @(*) begin
        hundreds = selected_result / 100;          // Hundreds place
        tens = (selected_result % 100) / 10;       // Tens place
        ones = selected_result % 10;              // Ones place
    end

    // LED Control Logic
    always @(*) begin
        if (switches >= 4'd0 && switches <= 4'd8) begin
            led = 1'b1;  // Turn LED on for valid selection
        end else begin
            led = 1'b0;  // Turn LED off for invalid selection
        end
    end

    // Refresh counter for multiplexing
       // Refresh counter for multiplexing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
            current_digit <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 20'd333_333) begin // ~180 Hz refresh rate
                refresh_counter <= 0;
                current_digit <= current_digit + 1; // Cycle through digits
                if (current_digit == 2) current_digit <= 0; // Wrap after hundreds
            end
        end
    end


    // 7-segment decoder
    always @(*) begin
        case (current_digit)
            2'd0: begin // Display ones place
                case (ones)
                    4'd0: seg = 7'b1000000; // 0
                    4'd1: seg = 7'b1111001; // 1
                    4'd2: seg = 7'b0100100; // 2
                    4'd3: seg = 7'b0110000; // 3
                    4'd4: seg = 7'b0011001; // 4
                    4'd5: seg = 7'b0010010; // 5
                    4'd6: seg = 7'b0000010; // 6
                    4'd7: seg = 7'b1111000; // 7
                    4'd8: seg = 7'b0000000; // 8
                    4'd9: seg = 7'b0010000; // 9
                    default: seg = 7'b1111111; // Blank
                endcase
                an = 4'b1110; // Enable the first digit (ones)
            end
            2'd1: begin // Display tens place
                case (tens)
                    4'd0: seg = 7'b1000000; // 0
                    4'd1: seg = 7'b1111001; // 1
                    4'd2: seg = 7'b0100100; // 2
                    4'd3: seg = 7'b0110000; // 3
                    4'd4: seg = 7'b0011001; // 4
                    4'd5: seg = 7'b0010010; // 5
                    4'd6: seg = 7'b0000010; // 6
                    4'd7: seg = 7'b1111000; // 7
                    4'd8: seg = 7'b0000000; // 8
                    4'd9: seg = 7'b0010000; // 9
                    default: seg = 7'b1111111; // Blank
                endcase
                an = 4'b1101; // Enable the second digit (tens)
            end
            2'd2: begin // Display hundreds place
                case (hundreds)
                    4'd0: seg = 7'b1000000; // 0
                    4'd1: seg = 7'b1111001; // 1
                    4'd2: seg = 7'b0100100; // 2
                    4'd3: seg = 7'b0110000; // 3
                    4'd4: seg = 7'b0011001; // 4
                    4'd5: seg = 7'b0010010; // 5
                    4'd6: seg = 7'b0000010; // 6
                    4'd7: seg = 7'b1111000; // 7
                    4'd8: seg = 7'b0000000; // 8
                    4'd9: seg = 7'b0010000; // 9
                    default: seg = 7'b1111111; // Blank
                endcase
                an = 4'b1011; // Enable the third digit (hundreds)
            end
        endcase
        dp = 1; // Turn off the decimal point
    end

endmodule
