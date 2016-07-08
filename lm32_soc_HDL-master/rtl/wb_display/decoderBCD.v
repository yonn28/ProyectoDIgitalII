`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:35:02 12/03/2015 
// Design Name: 
// Module Name:    decoderBCD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module decoderBCD(
       input  [3:0] bcd,     
		output  reg [0:6] sseg
			
    );
	 

always @(*)	
	begin
	case(bcd)

	       4'b0000:  sseg[0:6]= 7'b0000001;
               4'b0001:  sseg[0:6]= 7'b1001111;
               4'b0010:  sseg[0:6]= 7'b0010010;
               4'b0011:  sseg[0:6]= 7'b0000110;
               4'b0100:  sseg[0:6]= 7'b1001100;
               4'b0101:  sseg[0:6]= 7'b0100100;
               4'b0110:  sseg[0:6]= 7'b0100000;
               4'b0111:  sseg[0:6]= 7'b0001111;
               4'b1000:  sseg[0:6]= 7'b0000000;
               
               
		default   sseg[0:6]=  7'b0000100;

    endcase
 end

endmodule
