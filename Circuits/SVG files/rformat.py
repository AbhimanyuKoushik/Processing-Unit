def decode_r_format(hex_value):
    try:
        # Convert hex string (8 hex digits) to 32-bit integer
        instruction = int(hex_value, 16)

        # Extract fields
        opcode = instruction & 0x7F                  # bits 0–6
        funct3 = (instruction >> 12) & 0x7           # bits 12–14
        funct7 = (instruction >> 25) & 0x7F          # bits 25–31

        print(f"\nInstruction: 0x{instruction:08X}")
        print(f"Opcode  : {opcode:07b} (0x{opcode:02X})")
        print(f"funct3  : {funct3:03b} (0x{funct3:X})")
        print(f"funct7  : {funct7:07b} (0x{funct7:02X})\n")

    except ValueError:
        print("❌ Invalid input. Please enter a valid 8-digit hexadecimal number.")


def main():
    print("R-format Instruction Decoder")
    print("Enter an 8-digit hexadecimal number (or type 'exit' to quit).")
    print("-------------------------------------------------------------")

    while True:
        user_input = input("Hex: ").strip()

        if user_input.lower() == "exit":
            print("Exiting decoder. Goodbye!")
            break

        # Validate input length and characters
        if len(user_input) != 8 or not all(c in "0123456789abcdefABCDEF" for c in user_input):
            print("❌ Please enter exactly 8 hexadecimal digits (e.g., 00C58533).")
            continue

        decode_r_format(user_input)


if __name__ == "__main__":
    main()

