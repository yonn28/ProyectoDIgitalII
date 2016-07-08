//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module system_tb;

//----------------------------------------------------------------------------
// Parameter (may differ for physical synthesis)
//----------------------------------------------------------------------------
parameter tck              = 10;       // clock period in ns
parameter uart_baud_rate   = 1152000;  // uart baud rate for simulation 

parameter clk_freq = 1000000000 / tck; // Frequenzy in HZ
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
reg        clk;
reg        rst;
reg     [7:0]gpio0_io;     

/*wire       led;*/

//----------------------------------------------------------------------------
// UART STUFF (testbench uart, simulating a comm. partner)
//----------------------------------------------------------------------------
//wire        led;

reg         uart_rxd;
wire        uart_txd;

reg      spi_miso;
wire 	spi_mosi;
wire  	spi_clk;
wire    spi_CE;

wire 	i2c_sda;
wire 	i2c_scl;

wire	 [7:0]gpio_io;
reg     [7:0]gpio_dir;
reg     [7:0]data;


   genvar    i;
   generate 
      for (i=0;i<8;i=i+1)  begin: gpio_tris
	 assign gpio_io[i] = ~(gpio_dir[i]) ? data[i] : 1'bz;

	 end
   endgenerate

//----------------------------------------------------------------------------
// Device Under Test 
//----------------------------------------------------------------------------
system #(
	.clk_freq(           clk_freq         ),
	.uart_baud_rate(     uart_baud_rate   )
) dut  (
	.clk(          clk    ),
	// Debug
	//.led( 		led 	),
	.rst(         rst    ),
	
	// Uart
	.uart_rxd(uart_rxd),
	.uart_txd(uart_txd),

	//SPI
	.spi_miso(spi_miso),
	.spi_mosi(spi_mosi),
	.spi_clk(spi_clk),
	.spi_CE(spi_CE),

	//I2C
	
	.i2c_sda(i2c_sda),
	.i2c_scl(i2c_scl),
	
	//GPIO
	.gpio0_io( gpio_io )

);





/* Clocking device */
initial         clk <= 0;
always #(tck/2) clk <= ~clk;

always begin
	#700 spi_miso=~spi_miso;
	
end


/* Simulation setup */
initial begin

        
	#0 spi_miso = 1'b0;
	$dumpfile("system_tb.vcd");
	//$monitor("%b,%b,%b,%b",clk,rst,uart_txd,uart_rxd);
	$dumpvars(-1, dut,spi_miso);
	//$dumpvars(-1,clk,rst,uart_txd);
	// reset
	#0  rst <= 0;
	#100  rst <= 1;
	#10 gpio_dir <= 8'hf0;
	#10000 data[3:0] <= 4'hF;
	#10000 data[3:0] <= 4'h8;
	#10000 data[3:0] <= 4'h4;
	#10000 data[3:0] <= 4'hc;
	
	#10000 spi_miso = 1'b1;
	
	 

	#(tck*10000) $finish;
end



endmodule
