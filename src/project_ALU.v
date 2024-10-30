/*
 * Copyright (c) 2024 Gabriela Alfaro - UVG 
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
endmodule

 module ALU_4B (
     input  wire [3:0] ui_in_A      // Primer operando
     input  wire [7:4] ui_in_B      // Segundo operando
     
     input  wire [2:0] uio_in_opcode,         //opcode  

     output wire [7:0] uo_out_result,  //resultado

     output wire [7:0] uio_out,        // 0 bit -> zero, 1 bit -> overflow

    );

    always @(*) begin

    overflow = 0;                       // Inicializar overflow a 0

    case (opcode):

        3'b000: begin // Suma
            uo_out_result = in_A + in_B;
            overflow = (uo_out_result > 4'b1111);
            end
            
        3'b001: begin // Resta
            uo_out_result = in_A - in_B;
            overflow = (uo_out_result < 4'b0000);
            end

        3'b010: begin                      // Multiplicacion
            uo_out_result= in_A * in_B;
            end

        3'b011: begin                      // Division
            if (B != 0)
               uo_out_result = in_A / in_B;
            else
                uo_out_result = 8'b00000000;  // Evitar division por cero
            end

        default: begin
                uo_out_result = 8'b00000000;  // Operacion no valida
            end
    endcase
    
    zero = (out_result == 8'b00000000);
    end
   
  // List all unused inputs to prevent warnings
     wire unused = &{ena, clk, rst_n, uio_oe ,1'b0};
     
endmodule 

 


