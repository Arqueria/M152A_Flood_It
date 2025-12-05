module leds_set(
    input wire [3:0] final_COLOR_NUM,
    output reg [15:0] led = 0,




    input wire BEGIN_GAME,
    input wire INITIALIZE_BOARD,
    input wire ACK_BEGIN_GAME,
    input wire INIT_INIT

);

integer i = 0;
reg [15:0] value = 0;


always @ (*)
begin

  value[15] = BEGIN_GAME;
  value[14] = INITIALIZE_BOARD;
  value[13] = ACK_BEGIN_GAME;
  value[12] = INIT_INIT;

  value[11:8] = 0;

    if(final_COLOR_NUM == 3)
		value[2:0] = 16'b0000000000000111;
    else if(final_COLOR_NUM == 4)
		value[3:0] = 16'b0000000000001111;
    else if(final_COLOR_NUM == 5)
		value[4:0] = 16'b0000000000011111;
    else if(final_COLOR_NUM == 6)
		value[5:0] = 16'b0000000000111111;
    else if(final_COLOR_NUM == 7)
		value[6:0] = 16'b0000000001111111;
    else
		value[7:0] = 16'b0000000011111111;	
  
  led = value;
end
endmodule