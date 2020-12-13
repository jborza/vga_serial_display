module m640_to_320 (
	input wire [9:0] pixel_x, //0 to 640
	input wire [9:0] pixel_y, //0 to 480	
	output wire [13:0] address_byte,
	output wire [2:0] address_bit
);
//row_bytes := 320 / 8
//address_byte := pixel_y / 2 * row_bytes
assign address_byte = pixel_y[9:1] * 40 + pixel_x[9:4];
//address_bit := 	~(pixel_x / 2)
assign address_bit = ~pixel_x[3:1];

endmodule