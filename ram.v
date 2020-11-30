module ram #
(
	parameter RAM_BITS = 320*240/8,
	parameter RAM_ADDRESS_SIZE = $clog2(320*240/8)-1,
	parameter RAM_WORD_SIZE = 8
)
(
	clk, 
	read_address,
	d,
	write_address,
	q,
	we
);
	//inputs, outputs
	input wire clk;
	input [RAM_ADDRESS_SIZE:0] read_address;
	input [RAM_WORD_SIZE-1:0] d; //input data
	input [RAM_ADDRESS_SIZE:0] write_address;
	output reg [RAM_WORD_SIZE-1:0] q; //output data
	input  we;
	
	localparam RESOLUTION_X = 320;
	localparam RESOLUTION_Y = 240;

	reg [RAM_WORD_SIZE-1:0] mem [0:(RAM_BITS)-1];
	
	initial begin;
		$readmemb("ram.txt", mem);
	end
	
	always @(posedge clk) begin
		if(we) begin
			mem[write_address] <= d;
		end
		q <= mem[read_address];
	end

endmodule