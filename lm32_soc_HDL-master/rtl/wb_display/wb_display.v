module wb_display(
	input               clk,
	input               reset,
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
	output [0:6] segmentos,
	output dp,
	output [0:7] anodo
);

	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;

//---------------------------------------------------------
//display engine
		
reg [0:3]  bcd1=4'd0;
reg [0:3]  bcd2=4'd0;
reg [0:3]  bcd3=4'd0;
reg [0:3]  bcd4=4'd0;
reg [0:3]  bcd5=4'd0;
reg [0:3]  bcd6=4'd0;
reg [0:3]  bcd7=4'd0;
reg [0:3]  bcd8=4'd0;
reg [0:7]  point=8'd255;

	


	wire[0:3] bcd;
	FSMselect selector(clk,point,bcd8,bcd7,bcd6,bcd5,bcd4,bcd3,bcd2,bcd1,anodo,bcd,dp);
	decoderBCD deco( bcd, segmentos);


//------------------------------------------------------------

/*
memory map
bcd1
bcd2	
bcd3
bcd4
bcd5
bcd6
bcd7
bcd
point
*/

always @(posedge clk) begin
		if (reset == 1'b1) begin
			ack      <= 0;
			
			
		end else begin



			ack <= wb_stb_i & wb_cyc_i;
			
			if (wb_rd) begin           // read cycle
				 case (wb_adr_i[5:2])
					4'd0:begin
						wb_dat_o<={4'd0,bcd1};
					end
					4'd1:begin
						wb_dat_o<={4'd0,bcd2};
					end
					4'd2:begin
						wb_dat_o<={4'd0,bcd3};	
					end				
					4'd3:begin
						wb_dat_o<={4'd0,bcd4};	
					end					
					4'd4:begin
						wb_dat_o<={4'd0,bcd5};		
					end
					4'd5:begin
						wb_dat_o<={4'd0,bcd6};		
					end
					4'd6:begin
						wb_dat_o<={4'd0,bcd7};		
					end
					4'd7:begin
						wb_dat_o<={4'd0,bcd8};		
					end
					4'd8:begin
						wb_dat_o<=point;
					end

				endcase
			end
			
			
			if (wb_wr) begin // write cycle
				case (wb_adr_i[5:2])
					4'd0:begin
						bcd1<=wb_dat_i[3:0];	
					end
					4'd1:begin
						bcd2<=wb_dat_i[3:0];	
					end
					4'd2:begin
						bcd3<=wb_dat_i[3:0];	
					end				
					4'd3:begin
						bcd4<=wb_dat_i[3:0];	
					end					
					4'd4:begin
						bcd5<=wb_dat_i[3:0];	
					end
					4'd5:begin
						bcd6<=wb_dat_i[3:0];	
					end
					4'd6:begin
						bcd7<=wb_dat_i[3:0];	
					end
					4'd7:begin
						bcd8<=wb_dat_i[3:0];	
					end
					4'd8:begin
						point<=wb_dat_i[7:0];
					end

				endcase
			end			
			
	end
end
endmodule
