import serial
import time

def read_matrix_from_file(file_path):
    """
    Reads a matrix from a file.
    The file should contain one row per line with elements separated by spaces.
    """
    try:
        with open(file_path, 'r') as file:
            matrix = [list(map(int, line.strip().split())) for line in file]
        return matrix
    except Exception as e:
        print(f"Error reading matrix from file {file_path}: {e}")
        return None

def send_matrix(matrix):
    """
    Sends a matrix to the FPGA via UART.
    """
    if ser.is_open:
        try:
            for row in matrix:
                for element in row:
                    if 0 <= element <= 255:  # Ensure element fits 8 bits
                        ser.write(element.to_bytes(1, byteorder='big'))
                        print(f"Sent: {element}")
                        time.sleep(0.3)  # Add delay between bytes
                    else:
                        raise ValueError("Matrix elements must be between 0 and 255.")
        except Exception as e:
            print(f"Error sending matrix: {e}")
    else:
        print("Serial port not open!")

def receive_matrix(rows, cols):
    """
    Receives a matrix from the FPGA via UART.
    """
    result = []
    try:
        for _ in range(rows):
            row = []
            for _ in range(cols):
                data = ser.read(1)
                if data:
                    element = int.from_bytes(data, byteorder='big')
                    row.append(element)
                    print(f"Received: {element}")
            result.append(row)
        return result
    except Exception as e:
        print(f"Error receiving matrix: {e}")
        return None

def write_matrix_to_file(matrix, file_path):
    """
    Writes a matrix to a file.
    """
    try:
        with open(file_path, 'w') as file:
            for row in matrix:
                file.write(' '.join(map(str, row)) + '\n')
        print(f"Matrix written to {file_path}")
    except Exception as e:
        print(f"Error writing matrix to file {file_path}: {e}")

def main():
    """
    Main function for UART communication.
    """
    try:
        # Read matrices from files
        matrix_a = read_matrix_from_file('matrix_a.txt')
        matrix_b = read_matrix_from_file('matrix_b.txt')

        if matrix_a is None or matrix_b is None:
            print("Error: Could not read matrices from files.")
            return

        print("Sending Matrix A...")
        send_matrix(matrix_a)
        time.sleep(1)
        print("Sending Matrix B...")
        send_matrix(matrix_b)

        print("Waiting for FPGA to process...")
        time.sleep(1)  # Adjust delay based on FPGA processing time

        print("Receiving Result Matrix...")
        result = receive_matrix(3, 3)

        if result:
            print("Result Matrix:")
            for row in result:
                print(row)

            # Write result matrix to file
            write_matrix_to_file(result, 'result_matrix.txt')
        else:
            print("Failed to receive matrix.")

    except KeyboardInterrupt:
        print("\nExiting Program")
    finally:
        if ser.is_open:
            ser.close()
            print("Serial port closed.")

# Configure the serial port
ser = serial.Serial(
    port='COM8',               # Update with your serial port
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=1
)

if __name__ == "__main__":
    main()
