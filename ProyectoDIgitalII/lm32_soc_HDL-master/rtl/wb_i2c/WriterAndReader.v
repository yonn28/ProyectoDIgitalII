`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:14:59 06/20/2016 
// Design Name: 
// Module Name:    WriterAndReader 
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
module WriterAndReader(input clk, input[7:0] ByteToWrite,
	input WriteByte,Pointer,Read,StopCond,StartCond,Begin,EndHigh,Endlow,Midhigh,Midlow,
	output reg SclkEnable, output reg [7:0] ByteR, output reg WriteDone,Ack_w/*,Ack_R*/,ReadDone,StopDone,
	StartDone, inout I2C_SDA
);
	 
localparam  END_OR_BEGIN=8'd0;
localparam  IDLE=8'd1;
localparam  SCLK_ENABLE_DOWN=8'd22;

localparam  START_COND=8'd2;
localparam  START_DONE_O=8'd3;
localparam  START_DONE_T=8'd4;

localparam  STOP=8'd5;
localparam  FREE_BUS=8'd6;
localparam  STOP_DONE_O=8'd7;
localparam  STOP_DONE_T=8'd8;


localparam  WRITING_BYTE=8'd9;
localparam  ACK_BYTE_W=8'd10;
localparam  DECIDE=8'd11;
localparam  POINTER=8'd12;
localparam  SDA_L=8'd13;
localparam  WAIT_LOW_W=8'd14;
localparam  W_DONE_O=8'd15;
localparam  W_DONE_T=8'd16;

localparam  READING=8'd17;
localparam  ACK_BYTE_R=8'd18;
localparam  END_LOW_R=8'd19;
localparam  END_R_O=8'd20;
localparam  END_R_T=8'd21;

reg[7:0] state=8'd0;
reg[8:0] WriteTemp=9'd0;
reg[16:0] counterStop=17'd0;
reg[16:0] counterStart=17'd0;
reg[18:0] counterBusFree=19'd0;
reg[3:0]	counterBitsWriting=4'd0;
reg[3:0] couterBitsReading=4'd0;
reg[7:0] tempReaded=4'd0;
reg[2:0] sincronicer=3'd0;
reg Sda=1'b0;

assign I2C_SDA=(Sda)? 1'bz: 1'b0;

always @(negedge clk)begin//*--
case(state)
	END_OR_BEGIN:begin
		Sda<=1'b1;
		SclkEnable<=1'b0;
		StartDone<=1'b0;
		
		if(Begin)begin//-
			state<=IDLE;
		end else begin//-
			state<=END_OR_BEGIN;
		end//-
	end
	SCLK_ENABLE_DOWN:begin
		SclkEnable<=1'b0;
		if(sincronicer==3'd5)begin
			sincronicer<=3'd0;
			state<=IDLE;
		end else begin
			sincronicer<=sincronicer+1'b1;
			state<=SCLK_ENABLE_DOWN;
		end
	end
	IDLE:begin
		SclkEnable<=1'b0;
		if(StopCond)begin//-
			state<=STOP;
		end else begin//-
			if(StartCond)begin//--
				state<=START_COND;
			end else begin//--
				if(Read)begin//---
					SclkEnable<=1'b1;
					state<=READING;
				end else begin//---
						if(WriteByte)begin//----
							SclkEnable<=1'b1;
							WriteTemp<={1'b0,ByteToWrite};
							state<=WRITING_BYTE;
						end else begin//----
							state<=IDLE;
						end//----
				end//---
			end//--	
		end//-
	
	end
	//start core
	START_COND:begin
		Sda<=1'b0; //we asume that Sda was HIGH condition equal SCLK
		if(counterStart==17'd63798)begin
			counterStart<=17'd0;
			state<=START_DONE_O;
		end else begin
			state<=START_COND;
			counterStart<=counterStart+1'b1;
		end
	end
	START_DONE_O:begin
		StartDone<=1'b1;
		state<=START_DONE_T;
	end
	START_DONE_T:begin
		StartDone<=1'b0;
		//state<=IDLE;
		state<=SCLK_ENABLE_DOWN;
	end
	//stopcore
	STOP:begin
		Sda<=1'b0; //we make Sda low and after we make HIGH
		if(counterStart==17'd63798)begin
			counterStart<=17'd0;
			state<=FREE_BUS;
		end else begin
			state<=STOP;
			counterStart<=counterStart+1'b1;
		end
	end
	FREE_BUS:begin
		Sda<=1'b1;
		if(counterBusFree==19'd419000)begin
			counterBusFree<=19'd0;
			state<=STOP_DONE_O;
		end else begin
			state<=FREE_BUS;
			counterBusFree<=counterBusFree+1'b1;
		end
	end
	STOP_DONE_O:begin
	   Sda<=1'b1;
		StopDone<=1'b1;
		state<=STOP_DONE_T;
	end
	STOP_DONE_T:begin
		Sda<=1'b1;
		StopDone<=1'b0;
		//state<=IDLE;
		state<=SCLK_ENABLE_DOWN;
	end
	//Writing core
   WRITING_BYTE:begin
	if(counterBitsWriting==4'd9)begin//---
			state<=ACK_BYTE_W;
			counterBitsWriting<=4'd0;
			WriteTemp<=9'd0;
	end else begin//----
		if(Midlow)begin//--
			/*else begin//---*/
				WriteTemp<={WriteTemp[7:0],1'b0};
				state<=WRITING_BYTE;
				counterBitsWriting<=counterBitsWriting+1'b1;
			/*end//---*/
		end else begin //--
			Sda<=WriteTemp[8];
		end//--
	end//----
	
   end
   ACK_BYTE_W:begin
		Sda<=1'b1;
		if(EndHigh)begin//-
			state<=DECIDE;
		end else begin//-
			if(Midhigh)begin//--
				state<=ACK_BYTE_W;
				Ack_w<=I2C_SDA;
			end else begin//--
				state<=ACK_BYTE_W;
			end//--
		end//-
 
	end
   DECIDE:begin
		if(Pointer)begin//-
			state<=POINTER;
		end else begin//-
			state<=SDA_L;
		end//-
  
	end
	POINTER:begin
		Sda<=1'b1;
		state<=WAIT_LOW_W;
	end
	SDA_L:begin
		Sda<=1'b0;
		state<=WAIT_LOW_W;
	end
	WAIT_LOW_W:begin
		if(Endlow)begin
			state<=W_DONE_O;
		end else begin
			state<=WAIT_LOW_W;
		end
	end
	W_DONE_O:begin
		WriteDone<=1'b1;
		state<=W_DONE_T;
	end
	W_DONE_T:begin
		WriteDone<=1'b0;
		//state<=IDLE;
		state<=SCLK_ENABLE_DOWN;
	end
	//reading core
	READING:begin
		Sda<=1'b1;
		if((couterBitsReading==4'd8)&&Midlow)begin
			tempReaded<={tempReaded[6:0],I2C_SDA};
			ByteR<=tempReaded;
			tempReaded<=9'd0;
			couterBitsReading<=4'd0;
			state<=ACK_BYTE_R;
		end else begin//----
			if(Midhigh)begin//-
					if(couterBitsReading==4'd8)begin//--
						tempReaded<={tempReaded[6:0],I2C_SDA};
						ByteR<=tempReaded;
						//tempReaded<=9'd0;
					end else begin//--
						tempReaded<={tempReaded[6:0],I2C_SDA};
						couterBitsReading<=couterBitsReading+1'b1;
						state<=READING;
					end//--
			end else begin//-
					state<=READING;
			end//-
		end//----	
	end
	ACK_BYTE_R:begin
		Sda<=1'b0;
		//if(Midhigh)begin//-
			//Ack_R<=I2C_SDA;
			//state<=ACK_BYTE_R;
		//end else begin//-
			if(EndHigh)begin
				state<=END_LOW_R;
			end else begin
				state<=ACK_BYTE_R;
			end
		//end//-
	end
	END_LOW_R:begin
		Sda<=1'b0;
		if(Endlow)begin//-
			state<=END_R_O;
		end else begin//-
			state<=END_LOW_R;
		end//-
	end
	END_R_O:begin
		ReadDone<=1'b1;
		state<=END_R_T;
	end
	END_R_T:begin
		ReadDone<=1'b0;
		//state<=IDLE;
		state<=SCLK_ENABLE_DOWN;
	end
	
	default:begin
		state<=END_OR_BEGIN;
	end
	
endcase
end//*--

endmodule
