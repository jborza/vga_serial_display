module UART_TX #
(
	parameter CLOCK_FREQUENCY = 50_000_000,
	parameter BAUD_RATE       = 9600
)
(
	input  clockIN,
	input  nTxResetIN,
	input  [7:0] txDataIN,
	input  txLoadIN,
	output wire txIdleOUT,
	output wire txReadyOUT,
	output wire txOUT
);
localparam HALF_BAUD_CLK_REG_VALUE = (CLOCK_FREQUENCY / BAUD_RATE / 2 - 1);
localparam HALF_BAUD_CLK_REG_SIZE  = $clog2(HALF_BAUD_CLK_REG_VALUE);
reg [HALF_BAUD_CLK_REG_SIZE-1:0] txClkCounter = 0;
reg txBaudClk       = 1'b0;
reg [9:0] txReg     = 10'h001;
reg [3:0] txCounter = 4'h0; 
assign txReadyOUT = !txCounter[3:1];
assign txIdleOUT  = txReadyOUT & (~txCounter[0]);
assign txOUT      = txReg[0];
always @(posedge clockIN) begin : tx_clock_generate
	if(txIdleOUT & (~txLoadIN)) begin
		txClkCounter <= 0;
		txBaudClk    <= 1'b0;
	end
	else if(txClkCounter == 0) begin
		txClkCounter <= HALF_BAUD_CLK_REG_VALUE;
		txBaudClk    <= ~txBaudClk;
	end
	else begin
		txClkCounter <= txClkCounter - 1'b1;
	end
end
always @(posedge txBaudClk or negedge nTxResetIN) begin : tx_transmit
	if(~nTxResetIN) begin
		txCounter <= 4'h0;
		txReg[0]  <= 1'b1;
	end
	else if(~txReadyOUT) begin
		txReg     <= {1'b0, txReg[9:1]};
		txCounter <= txCounter - 1'b1;
	end
	else if(txLoadIN) begin
		txReg     <= {1'b1, txDataIN[7:0], 1'b0};
		txCounter <= 4'hA;
	end
	else begin
		txCounter <= 4'h0;
	end
end
endmodule