module UART_RX #
(
	parameter CLOCK_FREQUENCY = 50_000_000,
	parameter BAUD_RATE       = 9600
)
(
	input  clockIN,
	input  nRxResetIN,
	input  rxIN, 
	output wire rxIdleOUT,
	output wire rxReadyOUT,
	output wire [7:0] rxDataOUT
);
localparam HALF_BAUD_CLK_REG_VALUE = (CLOCK_FREQUENCY / BAUD_RATE / 2 - 1);
localparam HALF_BAUD_CLK_REG_SIZE  = $clog2(HALF_BAUD_CLK_REG_VALUE);
reg [HALF_BAUD_CLK_REG_SIZE-1:0] rxClkCounter = 0;
reg rxBaudClk = 1'b0;
reg [9:0] rxReg = 10'h000;
wire rx;
assign rxIdleOUT      = ~rxReg[0];
assign rxReadyOUT     = rxReg[9] & rxIdleOUT;
assign rxDataOUT[7:0] = rxReg[8:1];
RXMajority3Filter rxFilter
(
	.clockIN(clockIN),
	.rxIN(rxIN),
	.rxOUT(rx)
);
always @(posedge clockIN) begin : rx_clock_generate
	if(rx & rxIdleOUT) begin
		rxClkCounter <= HALF_BAUD_CLK_REG_VALUE;
		rxBaudClk    <= 0;
	end
	else if(rxClkCounter == 0) begin
		rxClkCounter <= HALF_BAUD_CLK_REG_VALUE;
		rxBaudClk    <= ~rxBaudClk;
	end
	else begin
		rxClkCounter <= rxClkCounter - 1'b1;
	end
end
always @(posedge rxBaudClk or negedge nRxResetIN) begin : rx_receive
	if(~nRxResetIN) begin
		rxReg <= 10'h000;
	end
	else if(~rxIdleOUT) begin
		rxReg <= {rx, rxReg[9:1]};
	end
	else if(~rx) begin
		rxReg <= 10'h1FF;
	end
end
endmodule