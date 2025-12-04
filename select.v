module select(
    input wire DISPLAY_CLOCK, // 1000 Hz
	input wire SLOW_MASTER_CLOCK, // 1 MHz
    input wire MASTER_CLOCK, // 100 MHz
    input wire BLINK_CLOCK, // 4 Hz
    input wire UP,
    input wire DOWN,
    input wire LEFT,
    input wire RIGHT,
    input wire CENTER,
	input wire [15:0] sw,
	
	
	
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire [15:0] led,
    
    output reg BEGIN_GAME = 0,
	input wire ACK_BEGIN_GAME,
	
	
	
	output reg [4:0] SIZE = 14,
	output reg [3:0] COLOR_NUM = 6,
	
	
	output reg [4:0] final_SIZE = 14,
	output reg [3:0] final_COLOR_NUM = 6,
	
	
	
	
	output reg MODE = 0,
	output reg [7:0] TRIES = 0,
	output reg COLOR_SEL_SIG = 0
    


);

reg ACK_UP = 0;
reg ACK_DOWN = 0;
reg ACK_LEFT = 0;
reg ACK_RIGHT = 0;
reg ACK_CENTER = 0;

reg UP_HELD = 0;
reg DOWN_HELD = 0;
reg LEFT_HELD = 0;
reg RIGHT_HELD = 0;
reg CENTER_HELD = 0;

reg sORc = 0; // 0 selects COLOR_NUM, 1 selects SIZE

reg UP_PREV = 0;
reg DOWN_PREV = 0;
reg LEFT_PREV = 0;
reg RIGHT_PREV = 0;
reg CENTER_PREV = 0;

reg INITIALIZE_BOARD = 0;
wire BOARD_READY;

reg [7:0] TOTAL_TRIES = 25;
reg [7:0] TRIES = 0;


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
		UP_HELD <= 1;

	if (DOWN_PREV == 0 && DOWN == 1)
		DOWN_HELD <= 1;

	if (LEFT_PREV == 0 && LEFT == 1)
		LEFT_HELD <= 1;

	if (RIGHT_PREV == 0 && RIGHT == 1)
		RIGHT_HELD <= 1;
		
	if (CENTER_PREV == 0 && CENTER == 1)
		CENTER_HELD <= 1;
	
	
	if (UP_PREV == 1 && UP == 0)
	begin
		UP_HELD <= 0;
		ACK_UP <= 0;
	end
		
	if (DOWN_PREV == 1 && DOWN == 0)
	begin
		DOWN_HELD <= 0;
		ACK_DOWN <= 0;
	end
		
	if (LEFT_PREV == 1 && LEFT == 0)
	begin
		LEFT_HELD <= 0;
		ACK_LEFT <= 0;
	end
		
	if (RIGHT_PREV == 1 && RIGHT == 0)
	begin
		RIGHT_HELD <= 0;
		ACK_RIGHT <= 0;
	end
		
	if (CENTER_PREV == 1 && CENTER == 0)
	begin
		CENTER_HELD <= 0;
	end
	
	if (BOARD_READY)
	   BEGIN_GAME <= 1;
	
	if (ACK_BEGIN_GAME)
	begin
	   BEGIN_GAME <= 0;
	   INITIALIZE_BOARD <= 0;
	   MODE <= 1;
	end
	
	if(MODE)
	begin
		
		
		
			
	end
	
end

always @ (posedge SLOW_MASTER_CLOCK)
begin
    if(~INITIALIZE_BOARD && ~MODE)
    begin
    
        if (LEFT_HELD)
        begin
            ACK_LEFT <= 1;
            if(~ACK_LEFT)
                sORc <= ~sORc;
        end
        
        if (RIGHT_HELD)
        begin
            ACK_RIGHT <= 1;
            if(~ACK_RIGHT)
                if(~MODE && ~INITIALIZE_BOARD)
					MODE <= 1; // IDK
        end
        
        if (UP_HELD)
        begin
            ACK_UP <= 1;
            if(~ACK_UP)
            begin
                if(sORc)
                    SIZE <= SIZE_CHANGE(0);
                else
                    COLOR_NUM <= COLOR_NUM_CHANGE(0);
            end
        end
        
        
        if (DOWN_HELD)
        begin
            ACK_DOWN <= 1;
            if(~ACK_DOWN)
            begin
                if(sORc)
                    SIZE <= SIZE_CHANGE(1);
                else
                    COLOR_NUM <= COLOR_NUM_CHANGE(1);		
            end
        end
		
		
		
	end
	
	
	
	
	if(CENTER_HELD)
	begin
		if(MODE)
			MODE <= 0;
		else
			MODE <= 1;	
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