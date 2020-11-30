module vga_display_top(
	input wire 	clk, 
	output wire vga_h_sync, 
	output wire vga_v_sync, 
	output wire [2:0] vga_rgb,
	input wire uart_rx,
	output wire uart_tx
);


//parameters
defparam uart.CLOCK_FREQUENCY = 50_000_000;
defparam uart.BAUD_RATE       = 3_000_000; //3_000_000;

defparam ram.RAM_WORD_SIZE = 8;

wire in_display_area;
wire [9:0] pixel_x;
wire [8:0] pixel_y;

//memory connections
wire [13:0] read_address;
wire [7:0] ram_out;
reg [13:0] write_address;
reg [7:0] ram_in;
reg we;

//25 mhz pixel clock
reg pixel_tick;


hvsync_generator syncgen(.clk(pixel_tick), 
	.vga_h_sync(vga_h_sync), 
	.vga_v_sync(vga_v_sync),
	.in_display_area(in_display_area), 
	.counter_x(pixel_x), 
	.counter_y(pixel_y));
	
ram ram(
   .clk(clk),
	.q(ram_out), 
	.d(ram_in), 
	.write_address(write_address), 
	.read_address(read_address), 
	.we(we)
);
	
pixel_generator pixgen(
	.clk(clk),
	.video_on(in_display_area),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.rgb(vga_rgb),
	.address_out(read_address),
	.data_in(ram_out)
);


// uart stuff
reg [7:0] txData;
reg txLoad  = 1'b0;
wire txReset = 1'b1;
reg rxReset = 1'b1;
wire [7:0] rxData;
wire txIdle;
wire txReady;
wire rxIdle;
wire rxReady;
UART uart
(
	.clockIN(clk),
	.nTxResetIN(txReset),
	.txDataIN(txData),
	.txLoadIN(txLoad),
	.txIdleOUT(txIdle),
	.txReadyOUT(txReady),
	.txOUT(uart_tx),
	.nRxResetIN(rxReset),
	.rxIN(uart_rx), 
	.rxIdleOUT(rxIdle),
	.rxReadyOUT(rxReady),
	.rxDataOUT(rxData)
);

reg [13:0] current_address;
reg do_rx_data = 1'b0;

// 25 mhz pixel clock
always @(posedge clk)
begin
	pixel_tick <= ~pixel_tick;
end

reg [12:0] period_counter;
reg next_pixel;


always @(posedge clk)
begin
	if(rxReady) begin
		//txLoad <= 1'b1;
		//txData <= rxData;
		rxReset <= 1'b0; //negative reset
		write_address <= current_address;				
		ram_in <= rxData;	
		current_address <= current_address + 1;
		//address wrap around
		if(current_address >= 9600-1)
			current_address <= 0;
		we <= 1'b1;
		do_rx_data <= 1'b1;
	end else if(do_rx_data) begin
		rxReset <= 1'b1; //negative reset
		do_rx_data <= 1'b0;
		we <= 1'b0;
	end

end
	
endmodule