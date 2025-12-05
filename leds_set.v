module leds_set(
    input wire [3:0] final_COLOR_NUM,
    output reg [15:0] led = 0
);

integer i = 0;

always @ (*)
begin
    if(final_COLOR_NUM == 3)
		led = 16'b0000000000000111;
    else if(final_COLOR_NUM == 4)
		led = 16'b0000000000001111;
    else if(final_COLOR_NUM == 5)
		led = 16'b0000000000011111;
    else if(final_COLOR_NUM == 6)
		led = 16'b0000000000111111;
    else if(final_COLOR_NUM == 7)
		led = 16'b0000000001111111;
    else
		led = 16'b0000000011111111;	
end
endmodule