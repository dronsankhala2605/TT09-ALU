`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Declare continuous signals for power and ground
  wire VPWR = 1'b1;  // Power supply
  wire VGND = 1'b0;  // Ground

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
    #10 rst_n = 1; // Release reset after 10ns
    #10 ena = 1;   // Enable after 20ns
  end

  // Instantiate your ALU module
  tt_um_alf19185_ALU U1 (
`ifdef GL_TEST
      .VPWR(VPWR),  // Connect to power using wire
      .VGND(VGND),  // Connect to ground using wire
`endif
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

endmodule
