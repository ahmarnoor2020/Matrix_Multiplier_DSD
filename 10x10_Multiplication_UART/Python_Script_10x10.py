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
        # Validate matrix dimensions
        if len(matrix) != 10 or any(len(row) != 10 for row in matrix):
            raise ValueError("Matrix must be 10x10.")
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
                        time.sleep(0.01)  # Reduced delay for faster transmission
                    else:
                        raise ValueError("Matrix elements must be between 0 and 255.")
            print("Matrix sent successfully.")
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
        for i in range(rows):
            row = []
            for j in range(cols):
                data = ser.read(1)
                if data:
                    element = int.from_bytes(data, byteorder='big')
                    row.append(element)
                    print(f"Received: {element}")
                else:
                    raise TimeoutError("Timeout while receiving data.")
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
        time.sleep(2)  # Adjust delay based on FPGA processing time
        print("Sending Matrix B...")
        send_matrix(matrix_b)

        print("Waiting for FPGA to process...")
        time.sleep(0.5)  # Adjust delay based on FPGA processing time

        print("Receiving Result Matrix...")
        result = receive_matrix(10, 10)  # Updated for 10x10 matrix

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
