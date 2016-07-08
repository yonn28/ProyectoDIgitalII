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
	inout scl, sda 
);

	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;

//---------------------------------------------------------
//display engine



//------------------------------------------------------------



always @(posedge clk) begin
		if (reset == 1'b1) begin
			ack      <= 0;
			
			
		end else begin



			ack <= wb_stb_i & wb_cyc_i;

			if (wb_rd) begin           // read cycle
				


				endcase
			end
			
			
			if (wb_wr) begin // write cycle
				case (wb_adr_i[5:2])
				
					
				endcase
			end

			

			
			
	end
end
endmodule
