module i2c_master_wb_top(
	input               clk,
	input               reset,
	// Wishbone bus
		// Wishbone bus
	input      [31:0]   wb_adr_i,
	input      [31:0]   wb_dat_i,
	output reg [31:0]   wb_dat_o,
	input      [ 3:0]   wb_sel_i,
	input               wb_cyc_i,
	input               wb_stb_i,
	output              wb_ack_o,
	input               wb_we_i,

	//I2C
	output scl,
	inout sda 
);

	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;


//-----------------------------------------------------------------------
//core i2c
reg Busy;
reg[7:0] ByteconfigurationOne=8'hD3;
reg[7:0] ByteconfigurationTwo=8'h83;

wire [7:0] byteOne;
wire [7:0] bytetwo;
wire ACKWriter;
wire ProcessDone;

i2cModule I2C(
	.clk(clk), 
	.beginer(Busy),
	.ByteconfigurationOne(ByteconfigurationOne),
	.ByteconfigurationTwo(ByteconfigurationTwo),
 	.byteOne(byteOne), 
	.bytetwo(bytetwo), 
	.I2C_SCLK(scl), 
  	.I2C_SDA(sda),
	.Error(ACKWriter),
	.ProcessDone(ProcessDone)
);
	
//---------------------------------------------------------------------
//memory map
/*
Busy
ByteReadedOne
ByteReadedTwo
ByteConfigurationOne
ByteConfigurationTwo
Start
*/

always @(posedge clk) begin
		if (reset == 1'b1) begin
			ack <= 0;
			
		end else begin

			ack <= wb_stb_i & wb_cyc_i;
			
			if(ProcessDone)begin//--
				Busy<=1'b0;
			end else begin//--
			
				if (wb_rd) begin           // read cycle
					case (wb_adr_i[5:2])
						4'b0000:begin
							wb_dat_o<={7'd0,Busy};
						end
						4'b0001:begin
							wb_dat_o<=byteOne;
						end
						4'b0010:begin
							wb_dat_o<=bytetwo;
						end
					endcase
				end
			
			
				if (wb_wr) begin // write cycle
					case (wb_adr_i[5:2])
						4'b0011:begin
							ByteconfigurationOne<=wb_dat_i[7:0];	
						end
						4'b0100:begin
							ByteconfigurationTwo<=wb_dat_i[7:0];
						end
						4'b0101:begin
							Busy<=wb_dat_i[0];
						end
					endcase
				end		
			end//--
	end
end
endmodule
