module select(
    input wire MASTER_CLOCK, // 100 MHz
    input wire UP,
    input wire DOWN,
    input wire LEFT,
    input wire RIGHT,
    input wire CENTER,
	input wire [15:0] sw,

	
	
	
	
	// Interactions with rand
	
    output reg INITIALIZE_BOARD = 0,
	input wire BOARD_READY,

	
	
 	// Interactions with game logic
	
	input wire INITIALIZED,

	input wire CURRENTLY_CHANGING_COLOR,
	output reg COLOR_SEL_SIG = 0,
	output reg [2:0] COLOR_SELECTED = 0,
    output reg BEGIN_GAME = 0,
	input wire ACK_BEGIN_GAME,
	output reg [4:0] SIZE = 14,
	output reg [3:0] COLOR_NUM = 6,

	// wires for digit display and leds
	output reg MODE = 1,
	output reg [7:0] TRIES = 0,
	output reg [7:0] TOTAL_TRIES = 25,
    output reg [4:0] final_SIZE = 14,
	output reg [3:0] final_COLOR_NUM = 6,
	output reg sORc = 0 // 0 selects COLOR_NUM, 1 selects SIZE


);

reg ACK_UP = 0;
reg ACK_DOWN = 0;
reg ACK_LEFT = 0;
reg ACK_RIGHT = 0;
reg ACK_CENTER = 0;

reg ACK_UPs = 0;
reg ACK_DOWNs = 0;
reg ACK_LEFTs = 0;
reg ACK_RIGHTs = 0;
reg ACK_CENTERs = 0;

reg UP_HELD = 0;
reg DOWN_HELD = 0;
reg LEFT_HELD = 0;
reg RIGHT_HELD = 0;
reg CENTER_HELD = 0;


reg UP_PREV = 0;
reg DOWN_PREV = 0;
reg LEFT_PREV = 0;
reg RIGHT_PREV = 0;
reg CENTER_PREV = 0;








function [7:0] getTTries;
input [4:0] CURR_SIZE;
input [3:0] CURR_COLOR_NUM;
begin
	if(CURR_SIZE == 2)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 1;
			4 : getTTries = 2;
			5 : getTTries = 2;
			6 : getTTries = 3;
			7 : getTTries = 4;
			8 : getTTries = 4;
		endcase
	end
	
	else if(CURR_SIZE == 6)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 5;
			4 : getTTries = 7;
			5 : getTTries = 8;
			6 : getTTries = 10;
			7 : getTTries = 12;
			8 : getTTries = 14;
		endcase
	end	
	
	else if(CURR_SIZE == 10)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 8;
			4 : getTTries = 11;
			5 : getTTries = 14;
			6 : getTTries = 17;
			7 : getTTries = 20;
			8 : getTTries = 23;
		endcase
	end
	
	else if(CURR_SIZE == 14)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 12;
			4 : getTTries = 16;
			5 : getTTries = 20;
			6 : getTTries = 25;
			7 : getTTries = 29;
			8 : getTTries = 33;
		endcase
	end	
	
	else if(CURR_SIZE == 18)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 16;
			4 : getTTries = 21;
			5 : getTTries = 26;
			6 : getTTries = 32;
			7 : getTTries = 37;
			8 : getTTries = 42;
		endcase
	end
	
	else if(CURR_SIZE == 22)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 19;
			4 : getTTries = 26;
			5 : getTTries = 32;
			6 : getTTries = 39;
			7 : getTTries = 45;
			8 : getTTries = 52;
		endcase
	end
	
	else if(CURR_SIZE == 26)
	begin
		case(CURR_COLOR_NUM)
			3 : getTTries = 23;
			4 : getTTries = 30;
			5 : getTTries = 38;
			6 : getTTries = 46;
			7 : getTTries = 54;
			8 : getTTries = 61;
		endcase
	end
	
end
endfunction







always @ (posedge MASTER_CLOCK)
begin
	UP_PREV <= UP;
	DOWN_PREV <= DOWN;
	LEFT_PREV <= LEFT;
	RIGHT_PREV <= RIGHT;
	CENTER_PREV <= CENTER;
	
	
	if (UP_PREV == 0 && UP == 1)
	begin
		ACK_UP <= 1;
		if(~ACK_UP && ~MODE)
		begin
			if(sORc)
				SIZE <= SIZE_CHANGE(0);
			else
				COLOR_NUM <= COLOR_NUM_CHANGE(0);
		end		
	end
	else 
	begin
		ACK_UP <= 0;
	end

	if (DOWN_PREV == 0 && DOWN == 1)
	begin
		ACK_DOWN <= 1;
		if(~ACK_DOWN && ~MODE)
		begin
			if(sORc)
				SIZE <= SIZE_CHANGE(1);
			else
				COLOR_NUM <= COLOR_NUM_CHANGE(1);		
		end
	end
	else 
	begin
		ACK_DOWN <= 0;
	end

	if (LEFT_PREV == 0 && LEFT == 1)
	begin
		ACK_LEFT <= 1;
        if(~ACK_LEFT && ~MODE)
            sORc <= ~sORc;
	end
	else 
	begin
		ACK_LEFT <= 0;
	end


	if(BEGIN_GAME == 1 || ACK_BEGIN_GAME == 1)
	begin
		MODE <= 1;
	end
	else if (RIGHT_PREV == 0 && RIGHT == 1)
	begin
		ACK_RIGHT <= 1;
		if(~ACK_RIGHT && INITIALIZED)
			MODE <= ~MODE;
	end
	else 
	begin
		ACK_RIGHT <= 0;
	end

	if(INITIALIZE_BOARD == 1)
	begin
		if(BOARD_READY == 1)
		begin
			INITIALIZE_BOARD <= 0;
			BEGIN_GAME <= 1;
		end
	end
	else if(BEGIN_GAME)
	begin
		if(ACK_BEGIN_GAME)
			BEGIN_GAME <= 0;
	end
	else if (CENTER_PREV == 0 && CENTER == 1)
	begin
		ACK_CENTER <= 1;
		if(~ACK_RIGHT && ~MODE)
		begin
			INITIALIZE_BOARD <= 1;
			final_SIZE <= SIZE;
			final_COLOR_NUM <= COLOR_NUM;
		    TOTAL_TRIES <= getTTries(SIZE, COLOR_NUM);
		end
	end
	else if (~INITIALIZED)
	begin
		INITIALIZE_BOARD <= 1;
		final_SIZE <= SIZE;
		final_COLOR_NUM <= COLOR_NUM;

	end
	else 
	begin
		ACK_CENTER <= 0;
	end	
end

reg SW0p = 0;
reg SW1p = 0;
reg SW2p = 0;
reg SW3p = 0;
reg SW4p = 0;
reg SW5p = 0;
reg SW6p = 0;
reg SW7p = 0;



always @ (posedge MASTER_CLOCK)
begin
if(MODE && ~BEGIN_GAME && ~INITIALIZE_BOARD && ~BOARD_READY && ~ACK_BEGIN_GAME && INITIALIZED)
begin
	SW0p <= sw[0];
	SW1p <= sw[1];
	SW2p <= sw[2];
	SW3p <= sw[3];
	SW4p <= sw[4];
	SW5p <= sw[5];
	SW6p <= sw[6];
	SW7p <= sw[7];

    if(COLOR_SEL_SIG || CURRENTLY_CHANGING_COLOR)
	begin
		if(CURRENTLY_CHANGING_COLOR)
			COLOR_SEL_SIG <= 0;
	end
	else if(SW0p == ~sw[0])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 0;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW1p == ~sw[1])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 1;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW2p == ~sw[2])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 2;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW3p == ~sw[3])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 3;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW4p == ~sw[4])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 4;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW5p == ~sw[5])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 5;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW6p == ~sw[6])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 6;
		COLOR_SEL_SIG <= 1;
	end
	else if(SW7p == ~sw[7])
	begin
		TRIES <= TRIES + 1;
		COLOR_SELECTED <= 7;
		COLOR_SEL_SIG <= 1;
	end
end
else if (INITIALIZE_BOARD)
begin   
    TRIES <= 0;
end
else if (~INITIALIZED)
begin
    SW0p <= sw[0];
	SW1p <= sw[1];
	SW2p <= sw[2];
	SW3p <= sw[3];
	SW4p <= sw[4];
	SW5p <= sw[5];
	SW6p <= sw[6];
	SW7p <= sw[7];
end

end



function [4:0] SIZE_CHANGE;
input DOWN;
begin
	if(SIZE == 2)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd26;
		else
			SIZE_CHANGE = 5'd6;
	end 
		
	else if(SIZE == 6)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd2;
		else
			SIZE_CHANGE = 5'd10;
	end
	
	else if(SIZE == 10)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd6;
		else
			SIZE_CHANGE = 5'd14;
	end
			
	else if(SIZE == 14)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd10;
		else
			SIZE_CHANGE = 5'd18;
	end
			
	else if(SIZE == 18)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd14;
		else
			SIZE_CHANGE = 5'd22;
	end
	
	else if(SIZE == 22)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd18;
		else
			SIZE_CHANGE = 5'd26;
	end
			
	else if(SIZE == 26)
	begin
		if(DOWN)
			SIZE_CHANGE = 5'd22;
		else
			SIZE_CHANGE = 5'd2;
	end
end
endfunction

function [3:0] COLOR_NUM_CHANGE;
input DOWN;
begin
	if (COLOR_NUM == 3)
	begin
		if (DOWN)
			COLOR_NUM_CHANGE = 4'd8;
		else
			COLOR_NUM_CHANGE = 4'd4;
	end
			
	else if (COLOR_NUM == 4)
	begin
		if (DOWN)
			COLOR_NUM_CHANGE = 4'd3;
		else
			COLOR_NUM_CHANGE = 4'd5;
	end

	else if (COLOR_NUM == 5)
	begin
		if (DOWN)
			COLOR_NUM_CHANGE = 4'd4;
		else
			COLOR_NUM_CHANGE = 4'd6;
	end

	else if (COLOR_NUM == 6)
	begin
		if (DOWN)
			COLOR_NUM_CHANGE = 4'd5;
		else
			COLOR_NUM_CHANGE = 4'd7;
	end
			
	else if (COLOR_NUM == 7)
	begin
		if (DOWN)
			COLOR_NUM_CHANGE = 4'd6;
		else
			COLOR_NUM_CHANGE = 4'd8;
	end
			
	else if (COLOR_NUM == 8)
	begin
		if (DOWN)
			COLOR_NUM_CHANGE = 4'd7;
		else
			COLOR_NUM_CHANGE = 4'd3;
	end
	
end
endfunction








endmodule