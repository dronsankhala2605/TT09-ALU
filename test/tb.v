`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns clock period
  end

  // Reset and enable signals
  initial begin
    rst_n = 0;
    ena = 0;
    #15 rst_n = 1; // Release reset after 15 ns
    #20 ena = 1;   // Enable after 20 ns
  end

  // Test sequence
  initial begin
    // Initialize inputs
    ui_in = 8'b0;
    uio_in = 8'b0;

    // Apply test vectors
    #30; // Wait for reset to be deactivated

    // Test Case 1: Addition (Opcode 000)
    ui_in = 8'b00001111;  // A = 15, B = 0 (binary: 00001111)
    uio_in = 8'b00000000; // Opcode = 000
    #10;

    // Test Case 2: Subtraction (Opcode 001)
    ui_in = 8'b00011111;  // A = 31, B = 0
    uio_in = 8'b00000001; // Opcode = 001
    #10;

    // Test Case 3: Multiplication (Opcode 010)
    ui_in = 8'b00000101;  // A = 5, B = 0
    uio_in = 8'b00000010; // Opcode = 010
    #10;

    // Test Case 4: Division (Opcode 011)
    ui_in = 8'b00001010;  // A = 10, B = 2
    uio_in = 8'b00000011; // Opcode = 011
    #10;

    // Additional test cases as needed
    #10 $finish;
  end

  // Replace tt_um_example with your module name:
  tt_um_alf19185_ALU uut (
`ifdef GL_TEST
      .VPWR(1'b1),
      .VGND(1'b0),
`endif
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

endmodule

