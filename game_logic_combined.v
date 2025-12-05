module game_logic(
    input wire CLOCK,
    input wire [2:0] INITIAL_BOARD [25:0][25:0],   
    output reg [2:0] GAME_BOARD [25:0][25:0],
    
    input wire [4:0] final_SIZE,
    
    input wire [2:0] COLOR_SELECTED,
    input wire COLOR_SEL_SIG,
    output reg CHANGING_COLOR = 0,
    
    output reg INIT_INIT = 0,
    input wire BEGIN_GAME,
    output reg ACK_BEGIN_GAME = 0
);

    reg [2:0] LOCAL_COLOR_SELECTED;
    reg DONE_CHANGING_COLOR = 0;

    integer i;
    integer j;

    // --- BFS Variables ---
    localparam BFS_IDLE          = 3'd0;
    localparam BFS_INIT          = 3'd1;
    localparam BFS_PROCESS_QUEUE = 3'd2;
    localparam BFS_CHECK_NEIGHBORS = 3'd3;
    localparam BFS_DONE          = 3'd4;

    reg [2:0] bfs_state = BFS_IDLE;
    reg [2:0] old_color;
    
    // Queue memory
    reg [9:0] queue [0:255]; 
    reg [7:0] head = 0; 
    reg [7:0] tail = 0; 
    reg [9:0] current_node;
    
    integer cur_r, cur_c;
    reg [2:0] neighbor_step;

    // --- ENABLE SIGNAL / TIMER ---
    // We use this to slow down the 100MHz clock to create an animation effect
    reg [19:0] anim_timer = 0; 
    localparam ANIM_SPEED = 10; // Adjust this value to change animation speed

    // --- SINGLE DRIVER BLOCK ---
    always @ (posedge CLOCK)
    begin
        // Priority 1: Reset / Initialize Game
        if(BEGIN_GAME)
        begin
            if(~ACK_BEGIN_GAME)
            begin
                // Copy Initial Board
                if (final_SIZE == 2) begin
                    for(i=0; i < 2; i = i + 1) for(j=0; j < 2; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end else if (final_SIZE == 6) begin
                    for(i=0; i < 6; i = i + 1) for(j=0; j < 6; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end else if (final_SIZE == 10) begin
                    for(i=0; i < 10; i = i + 1) for(j=0; j < 10; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end else if (final_SIZE == 14) begin
                    for(i=0; i < 14; i = i + 1) for(j=0; j < 14; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end else if (final_SIZE == 18) begin
                    for(i=0; i < 18; i = i + 1) for(j=0; j < 18; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end else if (final_SIZE == 22) begin
                    for(i=0; i < 22; i = i + 1) for(j=0; j < 22; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end else if (final_SIZE == 26) begin
                    for(i=0; i < 26; i = i + 1) for(j=0; j < 26; j = j + 1) GAME_BOARD[i][j] <= INITIAL_BOARD[i][j];
                end
                
                ACK_BEGIN_GAME <= 1;
                CHANGING_COLOR <= 0;
                INIT_INIT <= 1;
                
                // Reset BFS state
                bfs_state <= BFS_IDLE;
                head <= 0;
                tail <= 0;
                DONE_CHANGING_COLOR <= 0;
            end
        end
        else begin
            // Priority 2: Game Logic
            
            if(ACK_BEGIN_GAME) ACK_BEGIN_GAME <= 0; // Turn off start flag

            // Handshake Start
            else if(COLOR_SEL_SIG && ~CHANGING_COLOR)
            begin
                CHANGING_COLOR <= 1;
                LOCAL_COLOR_SELECTED <= COLOR_SELECTED;
                bfs_state <= BFS_IDLE; // Prepare BFS
            end
            
            // Handshake End
            else if(CHANGING_COLOR && DONE_CHANGING_COLOR)
            begin
                CHANGING_COLOR <= 0;
                DONE_CHANGING_COLOR <= 0;
            end

            // --- BFS ALGORITHM ---
            else if(CHANGING_COLOR && ~DONE_CHANGING_COLOR) begin
                
                // ENABLE LOGIC: Wait for the timer to fill up
                if (anim_timer < ANIM_SPEED) begin
                    anim_timer <= anim_timer + 1;
                end else begin
                    // Timer finished! Enable one step of logic
                    anim_timer <= 0; 
                    
                    case (bfs_state)
                        BFS_IDLE: begin
                            old_color <= GAME_BOARD[0][0];
                            if (GAME_BOARD[0][0] != LOCAL_COLOR_SELECTED) bfs_state <= BFS_INIT;
                            else DONE_CHANGING_COLOR <= 1;
                        end

                        BFS_INIT: begin
                            GAME_BOARD[0][0] <= LOCAL_COLOR_SELECTED;
                            queue[0] <= {5'd0, 5'd0};
                            head <= 0;
                            tail <= 1;
                            bfs_state <= BFS_PROCESS_QUEUE;
                        end

                        BFS_PROCESS_QUEUE: begin
                            if (head == tail) bfs_state <= BFS_DONE;
                            else begin
                                current_node = queue[head];
                                head <= head + 1;
                                cur_r = current_node[9:5];
                                cur_c = current_node[4:0];
                                neighbor_step <= 0;
                                bfs_state <= BFS_CHECK_NEIGHBORS;
                            end
                        end

                        BFS_CHECK_NEIGHBORS: begin
                            case (neighbor_step)
                                0: begin // UP
                                    if (cur_r > 0 && GAME_BOARD[cur_r - 1][cur_c] == old_color) begin
                                        GAME_BOARD[cur_r - 1][cur_c] <= LOCAL_COLOR_SELECTED;
                                        queue[tail] <= {cur_r[4:0] - 5'd1, cur_c[4:0]};
                                        tail <= tail + 1;
                                    end
                                    neighbor_step <= 1;
                                end
                                1: begin // DOWN
                                    if (cur_r < final_SIZE - 1 && GAME_BOARD[cur_r + 1][cur_c] == old_color) begin
                                        GAME_BOARD[cur_r + 1][cur_c] <= LOCAL_COLOR_SELECTED;
                                        queue[tail] <= {cur_r[4:0] + 5'd1, cur_c[4:0]};
                                        tail <= tail + 1;
                                    end
                                    neighbor_step <= 2;
                                end
                                2: begin // LEFT
                                    if (cur_c > 0 && GAME_BOARD[cur_r][cur_c - 1] == old_color) begin
                                        GAME_BOARD[cur_r][cur_c - 1] <= LOCAL_COLOR_SELECTED;
                                        queue[tail] <= {cur_r[4:0], cur_c[4:0] - 5'd1};
                                        tail <= tail + 1;
                                    end
                                    neighbor_step <= 3;
                                end
                                3: begin // RIGHT
                                    if (cur_c < final_SIZE - 1 && GAME_BOARD[cur_r][cur_c + 1] == old_color) begin
                                        GAME_BOARD[cur_r][cur_c + 1] <= LOCAL_COLOR_SELECTED;
                                        queue[tail] <= {cur_r[4:0], cur_c[4:0] + 5'd1};
                                        tail <= tail + 1;
                                    end
                                    bfs_state <= BFS_PROCESS_QUEUE;
                                end
                            endcase
                        end

                        BFS_DONE: begin
                            DONE_CHANGING_COLOR <= 1;
                        end
                    endcase
                end
            end
        end
    end

endmodule