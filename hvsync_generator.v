// VGA h/v sync generator for 640x480 @ 60 Hz

module hvsync_generator(
    input clk,
    output vga_h_sync,
    output vga_v_sync,
    output reg in_display_area,
    output reg [9:0] counter_x,
    output reg [9:0] counter_y
  );

    //hsync and vsync buffers
    reg vga_HS, vga_VS;

    //640x480 constants
    localparam H_DISPLAY = 640;
    localparam H_LEFT_BORDER = 48;
    localparam H_RIGHT_BORDER = 16;
    localparam H_RETRACE = 96;

    localparam V_DISPLAY = 480;
    localparam V_TOP_BORDER = 10;
    localparam V_BOTTOM_BORDER = 33;
    localparam V_RETRACE = 2;

    wire counter_x_maxed = (counter_x == H_DISPLAY + H_LEFT_BORDER + H_RETRACE + H_RIGHT_BORDER); // 16 + 48 + 96 + 640
    wire counter_y_maxed = (counter_y == V_DISPLAY + V_TOP_BORDER + V_RETRACE + V_BOTTOM_BORDER); // 10 + 2 + 33 + 480

    //x counter
    always @(posedge clk)
    if (counter_x_maxed)
        counter_x <= 0;
    else
        counter_x <= counter_x + 1;

    always @(posedge clk)
    begin
        if (counter_x_maxed)
        begin
        if(counter_y_maxed)
            counter_y <= 0;
        else
            counter_y <= counter_y + 1;
        end
    end

    always @(posedge clk)
    begin
        vga_HS <= (counter_x > (H_DISPLAY + H_RIGHT_BORDER) && (counter_x < (H_DISPLAY + H_RIGHT_BORDER + H_RETRACE)));   // active for 96 clocks
        vga_VS <= (counter_y > (V_DISPLAY + V_TOP_BORDER) && (counter_y < (V_DISPLAY + V_TOP_BORDER + V_RETRACE)));   // active for 2 clocks
    end

    always @(posedge clk)
    begin
        in_display_area <= (counter_x < H_DISPLAY) && (counter_y < V_DISPLAY);
    end

    // invert the hsync and vsync
    assign vga_h_sync = ~vga_HS;
    assign vga_v_sync = ~vga_VS;

endmodule
