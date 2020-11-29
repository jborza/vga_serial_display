module ram(
	clk, 
	read_address,
	d,
	write_address,
	q,
	we
);
	//inputs, outputs
	input wire clk;
	input [16:0] read_address;
	input d; //input data
	input [16:0] write_address;
	output reg q; //output data
	input  we;
	
	localparam RESOLUTION_X = 320;
	localparam RESOLUTION_Y = 240;

	reg mem [0:RESOLUTION_X*RESOLUTION_Y-1];
	
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