module RXMajority3Filter
(
	input clockIN,
	input rxIN,
	output wire rxOUT
);
reg [2:0] rxLock = 3'b111;
assign rxOUT = (rxLock[0] & rxLock[1]) | (rxLock[0] & rxLock[2]) | (rxLock[1] & rxLock[2]);
always @(posedge clockIN) begin
	rxLock <= {rxIN, rxLock[2:1]};
end
endmodule