module pixel_generator(
	input wire clk,
	input wire video_on,
	input wire [9:0] pixel_x, //0 to 640
	input wire [9:0] pixel_y, //0 to 480
	output reg [2:0] rgb,
	output reg [13:0] address_out,
	input wire [7:0] data_in
);

localparam MAX_X = 320;
localparam MAX_Y = 240;

reg[2:0] address_bit_previous;
wire[2:0] address_bit;
wire[13:0] address_byte;


m640_to_320 address_converter(
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.address_byte(address_byte),
	.address_bit(address_bit)
);

wire rgb_data = data_in[address_bit_previous];


always @(posedge clk) begin
	if(~video_on) begin
		rgb <= 3'b000; //blank
	end else begin
		// set the address of the byte we want to read on the next clock cycle
		address_out <= address_byte;
		// remember the bit number we want to use on the next clock cycle
		address_bit_previous <= address_bit;
		rgb <= {rgb_data, rgb_data, rgb_data};
	end

end

endmodule