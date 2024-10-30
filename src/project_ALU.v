/*
 * Copyright (c) 2024 Gabriela Alfaro - UVG 
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

 module tt_um_ALU_alf19185 (
     input  wire [3:0] ui_in_A      // Primer operando
     input  wire [7:4] ui_in_B      // Segundo operando
     
     input  wire [2:0] uio_in_opcode,         //opcode  

     output wire [7:0] uo_out_result,  //resultado

     output wire [7:0] uio_out,        // 0 bit -> zero, 1 bit -> overflow
     
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset

    );

    always @(*) begin

    overflow = 0;                       // Inicializar overflow a 0

    case (opcode):

        3'b000: begin // Suma
            uo_out_result = ui_in_A  + ui_in_B;
            uio_out [1] = (uo_out_result > 4'b1111); //Overflow
            end
            
        3'b001: begin // Resta
            uo_out_result = ui_in_A  - ui_in_B;
            overflow = (uo_out_result < 4'b0000);
            end

        3'b010: begin                      // Multiplicacion
            uo_out_result= ui_in_A  * ui_in_B;
            end

        3'b011: begin                      // Division
            if (ui_in_B != 0)
               uo_out_result = ui_in_A / ui_in_B;
            else
                uo_out_result = 8'b00000000;  // Evitar division por cero
            end

        default: begin
                uo_out_result = 8'b00000000;  // Operacion no valida
            end
    endcase
    
        uio_out [0] = (uo_out_result == 8'b00000000);
    end
   
  // List all unused inputs to prevent warnings
     wire unused = &{ena, clk, rst_n, uio_oe ,1'b0};
     
endmodule 

 


