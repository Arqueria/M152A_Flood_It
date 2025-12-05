module FloodIt(
    input wire clk,

    input wire [15:0] sw,
    
    input wire btnC,
    input wire btnU,
    input wire btnL,
    input wire btnR,
    input wire btnD,
    
    output wire [3:0] vgaRed,
    output wire [3:0] vgaBlue,
    output wire [3:0] vgaGreen,
    output wire Hsync,
    output wire Vsync,
    
    output wire [15:0] led,
    
    output wire [6:0] seg,
    output wire [3:0] an
);

// CLOCKS
wire HZ1;
wire HZ4;
wire HZ5;
wire HZ8;
wire HZ500;
wire HZ1000;
wire HZ5K;
wire HZ10K;
wire MHZ25;
wire MHZ50;

// DEBOUNCED Buttons
wire BTNC;
wire BTNU;
wire BTNL;
wire BTNR;
wire BTND;

clk_div clocks(
    .clk(clk),
    .HZ1(HZ1),
    .HZ4(HZ4),
    .HZ5(HZ5),
    .HZ8(HZ8),
    .HZ500(HZ500),
    .HZ1000(HZ1000),
    .HZ5K(HZ5K),
    .HZ10K(HZ10K),
    .MHZ25(MHZ25),
    .MHZ50(MHZ50)
);

btn_deb debouncer(
    .CLOCK(HZ500),
    .btnC(btnC),
    .btnR(btnR),
    .btnL(btnL),
    .btnU(btnU),
    .btnD(btnD),
    .BTNC(BTNC),
    .BTNR(BTNR),
    .BTNL(BTNL),
    .BTNU(BTNU),
    .BTND(BTND)
);

digit_display digit_display_module(
    .CLOCK(HZ1000), 
    .CLOCK_B(HZ4),
	.COLOR_NUM(COLOR_NUM),
	.SIZE(SIZE),
	.sORc(sORc),
	.MODE(MODE),
	.TRIES(TRIES),
	.TOTAL_TRIES(TOTAL_TRIES),
    .seg(seg),
    .an(an)
);

leds_set leds_set_module(
    .final_COLOR_NUM(final_COLOR_NUM),
    .led(led),
    .BEGIN_GAME(BEGIN_GAME),
    .INITIALIZE_BOARD(INITIALIZE_BOARD),
    .ACK_BEGIN_GAME(ACK_BEGIN_GAME),
    .INIT_INIT(INIT_INIT),
    .BOARD_READY(BOARD_READY)
);


wire MODE;
wire [7:0] TRIES;
wire [7:0] TOTAL_TRIES;
wire [4:0] final_SIZE;
wire [3:0] final_COLOR_NUM;
wire sORc;

wire [4:0] SIZE;

select select_module(

    .MASTER_CLOCK(HZ5K),
    .UP(BTNU),
    .DOWN(BTND),
    .LEFT(BTNL),
    .RIGHT(BTNR),
    .CENTER(BTNC),
	.sw(sw),

	// Interactions with rand
	
    .INITIALIZE_BOARD(INITIALIZE_BOARD),
	.BOARD_READY(BOARD_READY),

	
	
 	// Interactions with game logic
	
	.INIT_INIT(INIT_INIT),
	.CHANGING_COLOR(CHANGING_COLOR),
	.COLOR_SEL_SIG(COLOR_SEL_SIG),
	.COLOR_SELECTED(COLOR_SELECTED),
    .BEGIN_GAME(BEGIN_GAME),
	.ACK_BEGIN_GAME(ACK_BEGIN_GAME),
	.SIZE(SIZE),
	.COLOR_NUM(COLOR_NUM),

	// wires for digit display and leds
	.MODE(MODE),
	.TRIES(TRIES),
	.TOTAL_TRIES(TOTAL_TRIES),
    .final_SIZE(final_SIZE),
	.final_COLOR_NUM(final_COLOR_NUM),
	.sORc(sORc)
);


// select to generate_board

wire INITIALIZE_BOARD;
wire BOARD_READY;

generate_board generate_board_module(
	.CLOCK(HZ500),
	.seed(sw),
	.INITIALIZE_BOARD(INITIALIZE_BOARD),
	.final_SIZE(final_SIZE),
	.final_COLOR_NUM(final_COLOR_NUM),
	.INITIAL_BOARD(INITIAL_BOARD),
	.BOARD_READY(BOARD_READY)
);

// select to game_logic

wire INIT_INIT;
wire CHANGING_COLOR;
wire COLOR_SEL_SIG;
wire [2:0] COLOR_SELECTED;
wire BEGIN_GAME;
wire ACK_BEGIN_GAME;
wire [3:0] COLOR_NUM;



wire [2:0] INITIAL_BOARD [25:0][25:0];
wire [2:0] GAME_BOARD [25:0][25:0];

game_logic game_logic_module(
    .CLOCK(HZ500),
    .INITIAL_BOARD(INITIAL_BOARD), 
    .GAME_BOARD(GAME_BOARD),
    .final_SIZE(final_SIZE),
    .COLOR_SELECTED(COLOR_SELECTED),
    .COLOR_SEL_SIG(COLOR_SEL_SIG),
    .CHANGING_COLOR(CHANGING_COLOR),
    .INIT_INIT(INIT_INIT),
    .BEGIN_GAME(BEGIN_GAME),
    .ACK_BEGIN_GAME(ACK_BEGIN_GAME)
);



displayVGA displayVGA_module(
    .CLOCK(MHZ25),
    .GAME_BOARD(GAME_BOARD),
    .final_SIZE(final_SIZE),
    .INIT_INIT(INIT_INIT),
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen),
    .Hsync(Hsync),
    .Vsync(Vsync)
);


// COLOR CHART
// 0 Red
// 1 Green
// 2 Blue
// 3 Yellow
// 4 Cyan
// 5 Magenta
// 6 Orange
// 7 White
endmodule