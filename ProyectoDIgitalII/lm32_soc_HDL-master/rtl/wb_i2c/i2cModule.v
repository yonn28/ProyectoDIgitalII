`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:35:51 06/01/2016 
// Design Name: 
// Module Name:    i2cModule 
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
module i2cModule( input clk, input beginer,input[7:0] ByteconfigurationOne,input[7:0] ByteconfigurationTwo,output[7:0] byteOne, output[7:0] bytetwo, output I2C_SCLK, 
inout  I2C_SDA,output Error,output ProcessDone
    );
	 
wire WriteByte,Pointer,Read,StopCond,StartCond,Begin;
wire [7:0] ByteToWrite;

wire [7:0] ByteR;
wire WriteDone,Ack_w,ReadDone,StopDone,StartDone;
wire SclkEnable;

wire EndHigh,Endlow,Midhigh,Midlow;

Controller control(clk,beginer,ByteconfigurationOne,ByteconfigurationTwo,WriteDone,Ack_w,ReadDone,StopDone,StartDone,ByteR,ByteToWrite,WriteByte,Pointer,Read,StopCond,StartCond,Begin,byteOne,bytetwo,Error,ProcessDone);                     
WriterAndReader Core(clk,ByteToWrite,WriteByte,Pointer,Read,StopCond,StartCond,Begin,EndHigh,Endlow,Midhigh,Midlow,SclkEnable,ByteR,WriteDone,Ack_w,ReadDone,StopDone,StartDone,I2C_SDA);
Generator clock(clk,SclkEnable,StopCond,EndHigh,Endlow,Midhigh,Midlow,I2C_SCLK);


endmodule
