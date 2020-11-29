module UART #
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
	output wire txOUT,
	input  nRxResetIN,
	input  rxIN, 
	output wire rxIdleOUT,
	output wire rxReadyOUT,
	output wire [7:0] rxDataOUT
);
defparam  uart_tx.CLOCK_FREQUENCY = CLOCK_FREQUENCY;
defparam  uart_tx.BAUD_RATE       = BAUD_RATE;
UART_TX uart_tx
(
	.clockIN(clockIN),
	.nTxResetIN(nTxResetIN),
	.txDataIN(txDataIN),
	.txLoadIN(txLoadIN),
	.txIdleOUT(txIdleOUT),
	.txReadyOUT(txReadyOUT),
	.txOUT(txOUT)
);
defparam  uart_rx.CLOCK_FREQUENCY = CLOCK_FREQUENCY;
defparam  uart_rx.BAUD_RATE       = BAUD_RATE;
UART_RX uart_rx
(
	.clockIN(clockIN),
	.nRxResetIN(nRxResetIN),
	.rxIN(rxIN), 
	.rxIdleOUT(rxIdleOUT),
	.rxReadyOUT(rxReadyOUT),
	.rxDataOUT(rxDataOUT)
);
endmodule