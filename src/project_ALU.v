/*
 * Copyright (c) 2024 Gabriela Alfaro
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_alf19185_ALU (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // Clock (not used for combinational ALU)
    input  wire       rst_n     // Reset (not used for combinational ALU)
);

    // Map the ALU inputs and outputs to the provided ports
    wire [3:0] A = ui_in[3:0];         // Lower 4 bits of ui_in are A
    wire [3:0] B = ui_in[7:4];         // Upper 4 bits of ui_in are B
    wire [2:0] Opcode = uio_in[2:0];   // Use lower 3 bits of uio_in for Opcode

    reg [7:0] ALU_Result;
    reg Carry;
    reg Zero;

    // Assign ALU outputs to uo_out
    assign uo_out[7:0] = {Zero, Carry, ALU_Result[5:0]}; // Concatenate Zero, Carry, and the lower 6 bits of ALU_Result

    // Set unused outputs and IOs to 0
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

    // ALU Logic
    always @(*) begin
        // Default flags
        Carry = 1'b0;
        Zero = 1'b0;
        ALU_Result = 8'b0;

        case (Opcode)
            3'b000: begin  // Addition
                {Carry, ALU_Result} = {1'b0, A} + {1'b0, B}; 
                Zero = (ALU_Result == 8'b0);
            end
            3'b001: begin  // Subtraction
                ALU_Result = A - B;
                Zero = (ALU_Result == 8'b0);
            end
            3'b010: begin  // Multiplication
                ALU_Result = A * B;
                Zero = (ALU_Result == 8'b0);
            end
            3'b011: begin  // Division
                if (B != 0) begin
                    ALU_Result = A / B;
                    Zero = (ALU_Result == 8'b0);
                end else begin
                    ALU_Result = 8'b00000000;  // Set result to zero on division by zero
                    Zero = 1'b1;               // Set ZeroFlag to indicate division by zero
                end
            end
            3'b100: begin  // AND
                ALU_Result = A & B;
                Zero = (ALU_Result == 8'b0);
            end
            3'b101: begin  // OR
                ALU_Result = A | B;
                Zero = (ALU_Result == 8'b0);
            end
            3'b110: begin  // NOT
                ALU_Result = ~A;
                Zero = (ALU_Result == 8'b0);
            end
            3'b111: begin  // XOR
                ALU_Result = A ^ B;
                Zero = (ALU_Result == 8'b0);
            end
            default: begin
                ALU_Result = 8'b00000000;
                Zero = 1'b1;
            end
        endcase
    end

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
