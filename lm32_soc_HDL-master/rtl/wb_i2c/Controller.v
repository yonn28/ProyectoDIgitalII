`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:26 06/22/2016 
// Design Name: 
// Module Name:    Controller 
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
module Controller(input clk,beginer, input [7:0] ByteconfigurationOne,ByteconfigurationTwo,
	input WriteDone,Ack_w,ReadDone,StopDone,
	StartDone,input[7:0] ByteR, output reg[7:0] ByteToWrite,
	output reg WriteByte,Pointer,Read,StopCond,StartCond,Begin,
	output reg[7:0] byteOne, output reg[7:0] bytetwo,output Error, output reg ProcessDone
    );

localparam  IDLE_C=5'd0;
localparam  BEGIN_C=5'd1;
localparam  START_CONF=5'd2;
localparam  WRITE_SLAVE_ADRESS_CONF=5'd3;
localparam  WRITE_POINTER_CONF=5'd4;
localparam  WRITE_CONF_ONE=5'd5;
localparam  WRITE_CONF_TWO=5'd6;
localparam  STOP_CONF=5'd7;
localparam  WAIT_SEC=5'd8;
localparam  START=5'd9;
localparam  WRITE_SLAVE_ADRESS_READ=5'd10;
localparam  WRITE_POINTER_READ=5'd11;
localparam  STOP_READ=5'd12;
localparam  START_RED=5'd13;
localparam  WRITE_SLAVE_ADRESS_READ_HIGH=5'd14;
localparam  READ_BYTE_ONE=5'd15;
localparam  READ_BYTE_TWO=5'd16;
localparam  STOP_READ_END=5'd17;
localparam  GENERAL_DONE=5'd18;

reg[15:0] waiterFree=16'd0;
reg[4:0] stateC;
reg[3:0] WaiterForSincronice=1'b0;

assign Error=Ack_w;

always@(posedge clk)begin//*-
case(stateC)
	IDLE_C:begin
		if(beginer)begin//-
			stateC<=BEGIN_C;
		end else begin//-
			stateC<=IDLE_C;
		end//-
	end
	BEGIN_C:begin
		stateC<=START_CONF;
	end
	START_CONF:begin
		if(StartDone)begin
			stateC<=WRITE_SLAVE_ADRESS_CONF;
		end else begin
			stateC<=START_CONF;
		end
	end
	WRITE_SLAVE_ADRESS_CONF:begin
		if(WriteDone)begin//-
			stateC<=WRITE_POINTER_CONF;
		end else begin//-
			stateC<=WRITE_SLAVE_ADRESS_CONF;
		end//-
	end
	WRITE_POINTER_CONF:begin
		if(WriteDone)begin
			stateC<=WRITE_CONF_ONE;
		end else begin
			stateC<=WRITE_POINTER_CONF;
		end
	end
	WRITE_CONF_ONE:begin
		if(WriteDone)begin
			stateC<=WRITE_CONF_TWO;
		end else begin
			stateC<=WRITE_CONF_ONE;
		end
	end
	WRITE_CONF_TWO:begin
		if(WriteDone)begin
			stateC<=STOP_CONF;
		end else begin
			stateC<=WRITE_CONF_TWO;
		end
	end
	STOP_CONF:begin
		if(StopDone)begin
			stateC<=WAIT_SEC;
		end else begin
			stateC<=STOP_CONF;
		end
	end
	WAIT_SEC:begin
		if(waiterFree==16'd40000)begin
			waiterFree<=16'd0;
			stateC<=START;
		end else begin
			waiterFree<=waiterFree+1'b1;
			stateC<=WAIT_SEC;
		end
	end
	START:begin	
		if(StartDone)begin
			stateC<=WRITE_SLAVE_ADRESS_READ;
		end else begin
			stateC<=START;
		end
	end
	WRITE_SLAVE_ADRESS_READ:begin
		if(WriteDone)begin
			stateC<=WRITE_POINTER_READ;
		end else begin
			stateC<=WRITE_SLAVE_ADRESS_READ;
		end
	end
	WRITE_POINTER_READ:begin
		if(WriteDone)begin
			stateC<=STOP_READ;
		end else begin
			stateC<=WRITE_POINTER_READ;
		end
	end
	STOP_READ:begin
		if(StopDone)begin
			stateC<=START_RED;
		end else begin
			stateC<=STOP_READ;
		end
	end
	START_RED:begin
		if(StartDone)begin
			stateC<=WRITE_SLAVE_ADRESS_READ_HIGH;
		end else begin
			stateC<=START_RED;
		end
	end
	WRITE_SLAVE_ADRESS_READ_HIGH:begin
		if(WriteDone)begin
			stateC<=READ_BYTE_ONE;
		end else begin
			stateC<=WRITE_SLAVE_ADRESS_READ_HIGH;
		end
	end
   	READ_BYTE_ONE:begin
		if(ReadDone)begin
			byteOne<=ByteR;
			stateC<=READ_BYTE_TWO;
		end else begin
			stateC<=READ_BYTE_ONE;
		end
	end
	READ_BYTE_TWO:begin
		if(ReadDone)begin
			bytetwo<=ByteR;
			stateC<=STOP_READ_END;
		end else begin
			stateC<=READ_BYTE_TWO;
		end	
	end
	STOP_READ_END:begin
		if(StopDone)begin
			stateC<=GENERAL_DONE;
		end else begin
			stateC<=STOP_READ_END;
		end
	end
	GENERAL_DONE:begin
		if(WaiterForSincronice==4'd15)begin
			WaiterForSincronice<=4'd0;
			stateC<=IDLE_C;
		end else begin
			stateC<=GENERAL_DONE;
			WaiterForSincronice<=WaiterForSincronice+1'b1;
		end
	end
	default:begin
		stateC<=IDLE_C;
	end
endcase
end//*-

always@(*)begin//**-
case(stateC)
	IDLE_C:begin
		Begin=1'b0;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	BEGIN_C:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b1;
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	START_CONF:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b1;
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	WRITE_SLAVE_ADRESS_CONF:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b1;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;
		ByteToWrite=8'h90;
		//---------------
		ProcessDone=1'b0;
	end
	WRITE_POINTER_CONF:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;
		ByteToWrite=8'h01;
		//---------------
		ProcessDone=1'b0;		
	end
	WRITE_CONF_ONE:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;
		ByteToWrite=ByteconfigurationOne;
		//ByteToWrite=8'hD3;//Full scale 4.096 volts but don't exeed the VDD+0.3, if vdd<4 volts never reach full binary escale 
		//---------------
		ProcessDone=1'b0;
	end
	WRITE_CONF_TWO:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;
		ByteToWrite=ByteconfigurationTwo;
		//ByteToWrite=8'h83;
		//---------------
		ProcessDone=1'b0;
	end
	STOP_CONF:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b1;
		StartCond=1'b0;
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	WAIT_SEC:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;	
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	START:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b1;	
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	WRITE_SLAVE_ADRESS_READ:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b1;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;	
		ByteToWrite=8'h90;
		//---------------
		ProcessDone=1'b0;
	end
	WRITE_POINTER_READ:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	STOP_READ:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b1;
		StartCond=1'b0;	
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	START_RED:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b1;	
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	WRITE_SLAVE_ADRESS_READ_HIGH:begin
		Begin=1'b1;
		WriteByte=1'b1;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;		
		ByteToWrite=8'h91;
		//---------------
		ProcessDone=1'b0;
	end
        READ_BYTE_ONE:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b1;
		StopCond=1'b0;
		StartCond=1'b0;		
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	READ_BYTE_TWO:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b1;
		StopCond=1'b0;
		StartCond=1'b0;		
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	STOP_READ_END:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b1;
		StartCond=1'b0;		
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;
	end
	GENERAL_DONE:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;		
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b1;

	end
	default:begin
		Begin=1'b1;
		WriteByte=1'b0;
		Pointer=1'b0;
		Read=1'b0;
		StopCond=1'b0;
		StartCond=1'b0;		
		ByteToWrite=8'h00;
		//---------------
		ProcessDone=1'b0;		
	end
endcase
end//**-



endmodule
