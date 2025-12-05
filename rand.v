module generate_board(
	input wire CLOCK,
	
	input wire [15:0] seed,
	input wire INITIALIZE_BOARD,
	input wire [4:0] final_SIZE,
	input wire [3:0] final_COLOR_NUM,
	
	output reg [2:0] INITIAL_BOARD [25:0][25:0],
	output reg BOARD_READY = 0

);

reg [7:0] COL = 0;
reg [7:0] ROW = 0;
reg [2:0] CURR_COLOR = 0;

reg [15:0] R = 16'b1101101011010111;

reg running = 0;
reg setting = 0;

always @ (posedge CLOCK)
begin
	if(INITIALIZE_BOARD && ~running && ~BOARD_READY)
	begin
		running <= 1;
		
		if(seed)
			R <= seed;
		else
			R <= 16'b1101101011010111;

		CURR_COLOR <= R[1:0];

	end	
	else if (~INITIALIZE_BOARD && BOARD_READY)
	begin
		BOARD_READY <= 0;
	end
	else if ( ROW == final_SIZE )
	begin	
		running <= 0;
		BOARD_READY <= 1;
		ROW <= 0;
	end 
	else if(running)
	begin


		R <= { R[14:0] , ( (R[15]^R[13]) ^ R[12] ) ^ R[10] };
	

		
		if ( final_COLOR_NUM == 3 )
			CURR_COLOR <= R % 3;

		else if ( final_COLOR_NUM == 4 )
			CURR_COLOR <= R % 4;
	
		else if ( final_COLOR_NUM == 5 )
			CURR_COLOR <= R % 5;
	
		else if ( final_COLOR_NUM == 6 )
			CURR_COLOR <= R % 6;
		
		else if ( final_COLOR_NUM == 7 )
			CURR_COLOR <= R % 7;

		else if ( final_COLOR_NUM == 8 )
			CURR_COLOR <= R % 8;



		INITIAL_BOARD[ROW][COL] <= CURR_COLOR;
		if ( COL + 1 == final_SIZE )
		begin
			COL <= 0;
			ROW <= ROW + 1;
		end
		else
			COL <= COL + 1;

	end
end











endmodule