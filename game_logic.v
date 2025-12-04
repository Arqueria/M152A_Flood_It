module game_logic(
    input wire CLOCK, 
    input wire SLOW_CLOCK,
    input wire UPDATE_CLOCK, 
    input wire [2:0] INITIAL_BOARD [25:0][25:0],   
    output reg [2:0] GAME_BOARD [25:0][25:0],
    
    input wire [4:0] SIZE, // The board is SIZE by SIZE 
    input wire [3:0] COLOR_NUM, // The number of colors in the board,
                                // I don't think this variable will
                                // be of any use to this module.
    
    
    input wire [2:0] COLOR_SELECTED,
    input wire COLOR_SEL_SIG,
    output reg CHANGING_COLOR = 0,
    
    output reg INITIAL_INIT = 0,
    input wire START_NEW_GAME,
    output reg STARTED_GAME = 0
    
);

reg [2:0] LOCAL_COLOR_SELECTED;

reg DONE_CHANGING_COLOR = 0;

integer i;
integer j;

always @ (posedge CLOCK)
begin
    
	
	// Finite state machine stuff
    
    if(~START_NEW_GAME && STARTED_GAME)
        STARTED_GAME <= 0;

    if(~START_NEW_GAME && ~STARTED_GAME && INITIAL_INIT)
    begin
        if(COLOR_SEL_SIG && ~CHANGING_COLOR)
        begin
            CHANGING_COLOR <= 1;
            LOCAL_COLOR_SELECTED <= COLOR_SELECTED;
        end
        
        else if(CHANGING_COLOR && DONE_CHANGING_COLOR)
        begin
            CHANGING_COLOR <= 0;
            DONE_CHANGING_COLOR <= 0;
        end
    end


end

always @ (posedge SLOW_CLOCK)
begin
    if(START_NEW_GAME)
    begin
        if(~STARTED_GAME)
        begin
			if (SIZE == 2)
            for(i=0; i < 2; i = i + 1)
            for(j=0; j < 2; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
			
			else if (SIZE == 6)
			for(i=0; i < 6; i = i + 1)
            for(j=0; j < 6; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
            
			else if (SIZE == 10)
			for(i=0; i < 10; i = i + 1)
            for(j=0; j < 10; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
				
			else if (SIZE == 14)
			for(i=0; i < 14; i = i + 1)
            for(j=0; j < 14; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
				
			else if (SIZE == 18)
			for(i=0; i < 18; i = i + 1)
            for(j=0; j < 18; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
			
			else if (SIZE == 22)
			for(i=0; i < 22; i = i + 1)
            for(j=0; j < 22; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
				
			else if (SIZE == 26)
			for(i=0; i < 26; i = i + 1)
            for(j=0; j < 26; j = j + 1)
                GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
			
            STARTED_GAME <= 1;
            CHANGING_COLOR <= 0;
			INITIAL_INIT <= 1;
        end
    end
end

// NEW LOCAL REGISTERS/WIRES







//

always @(UPDATE_CLOCK)
begin
if(CHANGING_COLOR)
begin
// BFS ALGORITHM ONE LAYER AT A TIME TO MIMIC ANIMATION
// ALTER GAME_BOARD ONLY and any other registers you add.
// The color that was selected by the user is in LOCAL_COLOR_SELECTED
// Once the BFS algorithm has finished, set DONE_CHANGING_COLOR to 1 DONE_CHANGING_COLOR <= 1
// and the process will stop running after the cycle in which DONE_CHANGING_COLOR is set to 1.
// This is done by setting CHANGING_COLOR back to 0 once DONE_CHANGING_COLOR is 1.
// The actual color doesn't matter. We just use 000, 001, 010, 011, 100, 101, 110, 111 
// to denote the colors for now. Color logic is left to another module.



end


end
endmodule