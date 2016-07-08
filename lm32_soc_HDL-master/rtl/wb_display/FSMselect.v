`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:33:58 12/03/2015 
// Design Name: 
// Module Name:    FSMselect 
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
module FSMselect(
  input clk, input [0:7] point,
	input	[0:3]  bcd8,bcd7,bcd6,bcd5,bcd4,bcd3,bcd2,bcd1,
	output reg [0:7]anodo,
	output reg [0:3] bcd, output reg dp
    );
localparam DISPLAY_ONE=3'b000;
localparam DISPLAY_TWO=4'b001;
localparam	DISPLAY_THREE=4'b010;
localparam	DISPLAY_FOUR=4'b011;
localparam	DISPLAY_FIVE=4'b100;
localparam	DISPLAY_SIX=4'b101;
localparam	DISPLAY_SEVEN=4'b110;
localparam	DISPLAY_EIGHT=4'b111;

initial begin
  select = 0;
  state = 0;
 end



reg [0:2] state;	
reg[0:12] select;


always@(posedge clk)begin
		case(state)
		DISPLAY_ONE:begin		
			if(select==13'd5000)begin
					select=13'd0;
					state<=DISPLAY_TWO;
			end else begin
					state<=DISPLAY_ONE;
					select=select+1'b1;
			end
		
		end
		//----------------
		DISPLAY_TWO:begin
		
		if(select==13'd5000 )begin
			select=13'd0;
			state<=DISPLAY_THREE;
		end else begin
			state<=DISPLAY_TWO;
			select=select+1'b1;
		end
		
		end
		//-----------------------
		DISPLAY_THREE:begin
		
		if(select==13'd5000 )begin
			select=13'd0;
			state<=DISPLAY_FOUR;
		end else begin
			state<=DISPLAY_THREE;
			select=select+1'b1;		
		end

		end
		//------------------------
		
		DISPLAY_FOUR:begin
		
		if(select==13'd5000 )begin
			select=13'd0;
			state<=DISPLAY_FIVE;
		end else begin
			state<=DISPLAY_FOUR;
			select=select+1'b1;
		end		
		
	
		end
		//-------------------------
		DISPLAY_FIVE:begin
		
		if(select==13'd5000 )begin
			select=13'd0;
			state<=DISPLAY_SIX;
		end else begin
			state<=DISPLAY_FIVE;	
			select=select+1'b1;
		end

		end
		//-----------------------------
		DISPLAY_SIX:begin

		if(select==13'd5000 )begin
			select=13'd0;
			state<=DISPLAY_SEVEN;
		end else begin
			state<=DISPLAY_SIX;	
			select=select+1'b1;
		end


		end
		//--------------------------
		DISPLAY_SEVEN:begin
		
		if(select==13'd5000 )begin
			select=13'd0;
			state<=DISPLAY_EIGHT;
		end else begin
			state<=DISPLAY_SEVEN;
			select=select+1'b1;		
		end

		end
		//------------------------------
		DISPLAY_EIGHT:begin
		
		if(select==13'd5000 /*select==5000*/)begin
			select=13'd0;
			state<=DISPLAY_ONE;
		end else begin
			state<=DISPLAY_EIGHT;	
			select=select+1'b1;		
		end
			
		end
	
		//----------------------------------
		default:begin  
			select=0; 
			state<=DISPLAY_ONE;	
		end
		//------------------------------------
		endcase

end
always@(*)begin
		case(state)
		DISPLAY_ONE:begin
			bcd=bcd1;	
			anodo= 8'b11111110;
			//dp=1;//1
			dp=point[0];
		end
		//----------------
		DISPLAY_TWO:begin
			bcd=bcd2;
			anodo= 8'b11111101;
			//dp=1;//2
			dp=point[1];
		end
		//-----------------
		DISPLAY_THREE:begin
			bcd=bcd3;
			anodo= 8'b11111011;
			//dp=1;//3
			dp=point[2];
		end
		
		//---------------------
		DISPLAY_FOUR:begin
			bcd=bcd4;
			anodo= 8'b11110111;		
			//dp=1;//4
			dp=point[3];
		end
		//--------------------
		DISPLAY_FIVE:begin
			bcd=bcd5;
			anodo= 8'b11101111;
			//dp=0;//--//5
			dp=point[4];
		end
		//------------------
		DISPLAY_SIX:begin
			bcd=bcd6;
			anodo= 8'b11011111;
			//dp=1;//6
			dp=point[5];
		end
		//--------------------------
		DISPLAY_SEVEN:begin
			bcd=bcd7;
			anodo= 8'b10111111;
			//dp=1;//7
			dp=point[6];
		end
		//----------------------
		DISPLAY_EIGHT:begin
			bcd=bcd8;
			anodo= 8'b01111111;		
			//dp=1;//8
			dp=point[7];
		end
		//---------------------
		
		default:begin  		
			bcd=bcd1;
			anodo= 8'b11111110;
			dp=1;
		end

		endcase

end


endmodule
