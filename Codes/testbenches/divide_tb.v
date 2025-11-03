`timescale 1ns/1ps // Defines unit time and its precision

module divide_tb;

    reg [63:0] in1, in2;
    reg [1:0] flag;
    wire [63:0] out;

    divide dut (
        .in1(in1),
        .in2(in2),
        .flag(flag),
        .out(out)
    );

    initial begin
        $display("Time\tflag\tin1\t\t\tin2\t\t\tout");
        $monitor("%0t\t%b\t%h\t%h\t%h", $time, flag, in1, in2, out);

        in1 = 10; in2 = 5; flag = 0;
        #10;

        in1 = 20; in2 = -7; flag = 1;
        #10;

        in1 = 100; in2 = 20; flag = 2;
        #10;

        in1 = 5; in2 = -2; flag = 3;
        #10;

        $finish;
    end

endmodule


