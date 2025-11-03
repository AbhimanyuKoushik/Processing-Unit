`timescale 1ns/1ps

module register_file_tb;
    reg clk;
    reg [31:0] instruction;
    reg [63:0] write_data;
    reg RegWrite;
    wire [63:0] read_data1;
    wire [63:0] read_data2;
    
    // Instantiate register file
    register_file uut (
        .clk(clk),
        .instruction(instruction),
        .write_data(write_data),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        RegWrite = 0;
        instruction = 32'b0;
        write_data = 64'b0;
        
        #10;
        
        // Test 1: Write to integer register x5
        $display("\n=== Test 1: Integer Register x5 ===");
        instruction = 32'b0000000_00000_00000_000_00101_0110011; // rd=5, opcode=0110011
        write_data = 64'hDEADBEEF_CAFEBABE;
        RegWrite = 1;
        $display("WRITE: x[5] = 0x%h", write_data);
        #10;
        
        RegWrite = 0;
        instruction = 32'b0000000_00000_00101_000_00000_0110011; // rs1=5
        #10;
        $display("READ:  x[5] = 0x%h", read_data1);
        
        // Test 2: Write to FP register f10
        $display("\n=== Test 2: Floating-Point Register f10 ===");
        instruction = 32'b0000000_00000_00000_000_01010_1010011; // rd=10, opcode=1010011
        write_data = 64'h40000000_00000000;
        RegWrite = 1;
        $display("WRITE: f[10] = 0x%h", write_data);
        #10;
        
        RegWrite = 0;
        instruction = 32'b0000000_00000_01010_000_00000_1010011; // rs1=10
        #10;
        $display("READ:  f[10] = 0x%h", read_data1);
        
        // Test 3: Write to integer register x31
        $display("\n=== Test 3: Integer Register x31 ===");
        instruction = 32'b0000000_00000_00000_000_11111_0110011; // rd=31
        write_data = 64'hFFFFFFFF_FFFFFFFF;
        RegWrite = 1;
        $display("WRITE: x[31] = 0x%h", write_data);
        #10;
        
        RegWrite = 0;
        instruction = 32'b0000000_00000_11111_000_00000_0110011; // rs1=31
        #10;
        $display("READ:  x[31] = 0x%h", read_data1);
        
        // Test 4: Write to FP register f0
        $display("\n=== Test 4: Floating-Point Register f0 ===");
        instruction = 32'b0000000_00000_00000_000_00000_1010011; // rd=0, opcode=1010011
        write_data = 64'h3FF00000_00000000;
        RegWrite = 1;
        $display("WRITE: f[0] = 0x%h", write_data);
        #10;
        
        RegWrite = 0;
        instruction = 32'b0000000_00000_00000_000_00000_1010011; // rs1=0
        #10;
        $display("READ:  f[0] = 0x%h", read_data1);
        
        // Test 5: Dual read (integer registers)
        $display("\n=== Test 5: Dual Read Integer Registers ===");
        instruction = 32'b0000000_11111_00101_000_00000_0110011; // rs1=5, rs2=31
        #10;
        $display("READ:  x[5] = 0x%h", read_data1);
        $display("READ:  x[31] = 0x%h", read_data2);
        
        // Test 6: Dual read (FP registers)
        $display("\n=== Test 6: Dual Read FP Registers ===");
        instruction = 32'b0000000_01010_00000_000_00000_1010011; // rs1=0, rs2=10
        #10;
        $display("READ:  f[0] = 0x%h", read_data1);
        $display("READ:  f[10] = 0x%h", read_data2);
        
        // Test 7: Verify integer and FP are separate
        $display("\n=== Test 7: Verify Separate Register Banks ===");
        $display("Integer x[0] vs FP f[0] should be different:");
        instruction = 32'b0000000_00000_00000_000_00000_0110011; // integer rs1=0
        #10;
        $display("READ:  x[0] = 0x%h (integer bank)", read_data1);
        instruction = 32'b0000000_00000_00000_000_00000_1010011; // FP rs1=0
        #10;
        $display("READ:  f[0] = 0x%h (FP bank)", read_data1);
        
        // Test 8: Overwrite existing register
        $display("\n=== Test 8: Overwrite Register x5 ===");
        instruction = 32'b0000000_00000_00101_000_00000_0110011; // rs1=5
        #10;
        $display("BEFORE: x[5] = 0x%h", read_data1);
        
        instruction = 32'b0000000_00000_00000_000_00101_0110011; // rd=5
        write_data = 64'h12345678_9ABCDEF0;
        RegWrite = 1;
        $display("WRITE:  x[5] = 0x%h", write_data);
        #10;
        
        RegWrite = 0;
        instruction = 32'b0000000_00000_00101_000_00000_0110011; // rs1=5
        #10;
        $display("AFTER:  x[5] = 0x%h", read_data1);
        
        // Test 9: RegWrite disabled (should not write)
        $display("\n=== Test 9: RegWrite Disabled ===");
        instruction = 32'b0000000_00000_00001_000_00000_0110011; // rs1=1
        #10;
        $display("BEFORE: x[1] = 0x%h", read_data1);
        
        instruction = 32'b0000000_00000_00000_000_00001_0110011; // rd=1
        write_data = 64'hBADBADBA_DBADBAD0;
        RegWrite = 0; // Write disabled
        $display("WRITE DISABLED: Attempting x[1] = 0x%h", write_data);
        #10;
        
        instruction = 32'b0000000_00000_00001_000_00000_0110011; // rs1=1
        #10;
        $display("AFTER:  x[1] = 0x%h (should be unchanged)", read_data1);
        
        // Test 10: Boundary test - write multiple registers
        $display("\n=== Test 10: Write Multiple Registers ===");
        instruction = 32'b0000000_00000_00000_000_00001_0110011; // x[1]
        write_data = 64'h0000000000000001;
        RegWrite = 1;
        $display("WRITE: x[1] = 0x%h", write_data);
        #10;
        
        instruction = 32'b0000000_00000_00000_000_00010_0110011; // x[2]
        write_data = 64'h0000000000000002;
        $display("WRITE: x[2] = 0x%h", write_data);
        #10;
        
        instruction = 32'b0000000_00000_00000_000_00011_0110011; // x[3]
        write_data = 64'h0000000000000003;
        $display("WRITE: x[3] = 0x%h", write_data);
        #10;
        
        RegWrite = 0;
        instruction = 32'b0000000_00010_00001_000_00000_0110011; // rs1=1, rs2=2
        #10;
        $display("READ:  x[1] = 0x%h, x[2] = 0x%h", read_data1, read_data2);
        
        instruction = 32'b0000000_00011_00010_000_00000_0110011; // rs1=2, rs2=3
        #10;
        $display("READ:  x[2] = 0x%h, x[3] = 0x%h", read_data1, read_data2);
        
        $display("\n=== All Tests Completed ===\n");
        $finish;
    end
endmodule

