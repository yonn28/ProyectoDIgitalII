`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:03 06/20/2016 
// Design Name: 
// Module Name:    Generator 
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
module Generator(input clk,SclkEnable,StopCond,
output reg EndHigh,Endlow,Midhigh,Midlow,output I2C_SCLK
);

localparam  IDLE_G=4'd0;
localparam 	LOW_G=4'd1;
localparam  MID_LOW_G=4'd2;
localparam  END_LOW_G=4'd3;
localparam  DECIDE_G=4'd4;
localparam  HIGH_G=4'd5;
localparam  MID_HIGH_G=4'd6;
localparam  END_HIGH_G=4'd7;

reg[3:0] State=4'd0;
reg[15:0] couterLow=16'd0;
reg[2:0] WaiterSincronice=3'b0;
reg[15:0] counterHigh=16'd0;

reg sclk=1'b1;
//assign I2C_SCLK=sclk;
assign I2C_SCLK=(sclk)? 1'bz: 1'b0;	

always@(posedge clk)begin
case(State)
	IDLE_G:begin
		if(SclkEnable)begin//-
			State<=LOW_G;
		end else begin//-
			State<=IDLE_G;
		end//-
	end
	LOW_G:begin
	if(~SclkEnable)begin//----
		State<=LOW_G;
	end else begin//----
		if(couterLow==16'd19998)begin//-
			State<=MID_LOW_G;
		end else begin//-
			if(couterLow==16'd39995)begin//--
				couterLow<=16'd0;
				State<=END_LOW_G;
			end else begin//--
				couterLow<=couterLow+1'b1;
			end//--
		end//-
	end//----
	
	end
	MID_LOW_G:begin
		State<=LOW_G;
		couterLow<=couterLow+1'b1;
	end
	END_LOW_G:begin
		
		if(WaiterSincronice==3'd5)begin//-
			WaiterSincronice<=3'd0;
			State<=DECIDE_G;
		end else begin//-
			State<=END_LOW_G;
			WaiterSincronice<=WaiterSincronice+1'b1;
		end//-
		
	end
	DECIDE_G:begin
		if(~SclkEnable)begin//-
			if(StopCond&&~SclkEnable)begin//--
				State<=IDLE_G;
			end else begin//--
				State<=LOW_G;
			end//--
		end else begin//-
			//if(StopCond)begin//--
				//State<=IDLE_G;
			//end else begin//--
				State<=HIGH_G;
			//end//--
		end//-
	end
	HIGH_G:begin
		if(counterHigh==16'd39999)begin//-
			counterHigh<=16'd0;
			State<=END_HIGH_G;
		end else begin//-
			if(counterHigh==16'd20000)begin//--
				State<=MID_HIGH_G;
			end else begin//--
				State<=HIGH_G;
				counterHigh<=counterHigh+1'b1;
			end//--
		end//-
	end
	MID_HIGH_G:begin
		State<=HIGH_G;
		counterHigh<=counterHigh+1'b1;
	end
	END_HIGH_G:begin
		State<=LOW_G;
	end
	default:begin
		State<=IDLE_G;
	end
endcase
end


always@(*)begin
case(State)
	IDLE_G:begin
	
		sclk<=1'b1;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b0;
	
	end
	LOW_G:begin
	
		sclk<=1'b0;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b0;
	
	end
	MID_LOW_G:begin
	
		sclk<=1'b0;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b1;
	
	end
	END_LOW_G:begin
	
		sclk<=1'b0;
		EndHigh<=1'b0;
		Endlow<=1'b1;
		Midhigh<=1'b0;
		Midlow<=1'b0;
	
	end
	DECIDE_G:begin
	
		sclk<=1'b0;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b0;
	
	end
	HIGH_G:begin
	
		sclk<=1'b1;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b0;
	
	end
	MID_HIGH_G:begin
	
		sclk<=1'b1;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b1;
		Midlow<=1'b0;
	
	end
	END_HIGH_G:begin
	
		sclk<=1'b1;
		EndHigh<=1'b1;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b0;
	
	end
	default:begin
	
		sclk<=1'b0;
		EndHigh<=1'b0;
		Endlow<=1'b0;
		Midhigh<=1'b0;
		Midlow<=1'b0;
		
	end
endcase
end

endmodule
