module generate_board(
	input wire CLOCK,
	

	
	input wire [15:0] seed,
	input wire INITIALIZE_BOARD,
	input wire [4:0] SIZE,
	input wire [3:0] COLOR_NUM,
	
	
	
	output reg [2:0] initial_BOARD [25:0][25:0],
	output reg BOARD_READY = 0
	





);

reg [7:0] COL = 0;
reg [7:0] ROW = 0;
reg [2:0] CURR_COL = 0;

reg [15:0] R = 16'b1101101011010111;
reg [3:0] local_COLOR_NUM;
reg [4:0] local_SIZE;


reg running = 0;
reg setting = 0;



always @ (posedge CLOCK)
begin
	if(INITIALIZE_BOARD && ~running && ~BOARD_READY)
	begin
		running <= 1;
		setting <= 0;
		
		if(seed)
			R <= seed;
		else
			R <= 16'b1101101011010111;
			
		COL <= 0;
		ROW <= 0;
		local_COLOR_NUM <= COLOR_NUM;
		local_SIZE <= SIZE;
	end	
	else if (~INITIALIZE_BOARD && BOARD_READY)
	begin
		BOARD_READY <= 0;
	end
	else if ( ROW == local_SIZE )
	begin	
		running <= 0;
		BOARD_READY <= 1;
		ROW <= 0;
	end 
	else if(running)
	begin
		setting <= ~setting;
		if(~setting)
		begin
			R <= { R[15:1] , ( (R[15]^R[13]) ^ R[12] ) ^ R[10] };
		
			
			if ( local_COLOR_NUM == 3 )
				CURR_COL <= R % 3;

			else if ( local_COLOR_NUM == 4 )
				CURR_COL <= R % 4;
			
			else if ( local_COLOR_NUM == 5 )
				CURR_COL <= R % 5;
			
			else if ( local_COLOR_NUM == 6 )
				CURR_COL <= R % 6;
			
			else if ( local_COLOR_NUM == 7 )
				CURR_COL <= R % 7;
			
			else if ( local_COLOR_NUM == 8 )
				CURR_COL <= R % 8;
		end
		else if (setting)
		begin

			initial_BOARD[ROW][COL] <= CURR_COL;
			if ( COL + 1 == local_SIZE )
			begin
				COL <= 0;
				ROW <= ROW + 1;
			end
			else
				COL <= COL + 1;
		end
	end
end











endmodule