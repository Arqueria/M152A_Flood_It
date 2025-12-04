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

// Interconnects between selector and rand
wire INIT_NEW_BOARD;
wire NEW_BOARD_READY;

// Interconnects between selector and game logic
wire INITIAL_INITIALIZATION;
wire COLOR_SEL_SIG;
wire [2:0] COLOR_SELECTED;
wire BEGIN_GAME;
wire ACK_BEGIN_GAME;
wire [4:0] SIZE;
wire [3:0] COLOR_NUM;
wire CHANGING_COLOR;


// Interconnects between selector and digit and led displays
wire MODE;
wire [7:0] TRIES;
wire [7:0] TOTAL_TRIES;
wire [4:0] final_SIZE;
wire [3:0] final_COLOR_NUM;
wire sORc;


select selector(
    .MASTER_CLOCK(HZ5K),
    .UP(BTNU),
    .DOWN(BTND),
    .LEFT(BTNL),
    .RIGHT(BTNR),
    .CENTER(BTNC),
	.sw(sw),

    // rand
    .INITIALIZE_BOARD(INIT_NEW_BOARD),
    .BOARD_READY(NEW_BOARD_READY),

    // game logic
    .INITIALIZED(INITIAL_INITIALIZATION),
    .CURRENTLY_CHANGING_COLOR(CHANGING_COLOR),
    .COLOR_SEL_SIG(COLOR_SEL_SIG),
    .COLOR_SELECTED(COLOR_SELECTED),
    .BEGIN_GAME(BEGIN_GAME),
    .ACK_BEGIN_GAME(ACK_BEGIN_GAME),
    .SIZE(SIZE),
    .COLOR_NUM(COLOR_NUM),

    // digit and led displays
    .MODE(MODE),
    .TRIES(TRIES),
    .TOTAL_TRIES(TOTAL_TRIES),
    .final_SIZE(final_SIZE),
    .final_COLOR_NUM(final_COLOR_NUM),
    .sORc(sORc)
);


// Interconnects between selector and rand
wire INIT_NEW_BOARD;
wire NEW_BOARD_READY;

wire [2:0] INIT_BOARD [25:0][25:0];
wire [2:0] CURR_BOARD [25:0][25:0];


generate_board random_gen(
	.CLOCK(HZ500),
	.seed(led),
	.NEW_BOARD(INIT_NEW_BOARD),
	.SIZE(SIZE),
	.COLOR_NUM(COLOR_NUM),
	.initial_BOARD(INIT_BOARD),
	.READY(NEW_BOARD_READY)
);



// Interconnects between selector and digit and led displays
wire MODE;
wire [7:0] TRIES;
wire [7:0] TOTAL_TRIES;
wire [4:0] final_SIZE;
wire [3:0] final_COLOR_NUM;
wire sORc;



digit_display digdisp(
    .CLOCK(HZ1000),
    .CLOCK_B(HZ4),
	.COLOR_NUM(final_COLOR_NUM),
	.SIZE(final_SIZE),
	.sORc(sORc),
	.MODE(MODE),
	.TRIES(TRIES),
	.TOTAL_TRIES(TOTAL_TRIES),
    .seg(seg),
    .an(an)

);


wire INITIAL_INITIALIZATION;
wire COLOR_SEL_SIG;
wire [2:0] COLOR_SELECTED;
wire BEGIN_GAME;
wire ACK_BEGIN_GAME;
wire [4:0] SIZE;
wire [3:0] COLOR_NUM;




game_logic logic(
    .CLOCK(HZ500),
    .SLOW_CLOCK(HZ500),
    .UPDATE_CLOCK(HZ8),
    .INITIAL_BOARD(INIT_BOARD),
    .GAME_BOARD(CURR_BOARD),
    .SIZE(SIZE),
    .COLOR_NUM(COLOR_NUM),
    .COLOR_SELECTED(COLOR_SELECTED),
    .COLOR_SEL_SIG(COLOR_SEL_SIG),
    .CHANGING_COLOR(CHANGING_COLOR),
    .INITIAL_INIT(INITIAL_INITIALIZATION),
    .START_NEW_GAME(BEGIN_GAME),
    .STARTED_GAME(ACK_BEGIN_GAME)
);

displayVGA display(
    .CLOCK(MHZ25),
    .BOARD(CURR_BOARD),
    .SIZE(final_SIZE),
    .INITIALIZED(INITIAL_INITIALIZATION),
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen),
    .Hsync(Hsync),
    .Vsync(Vsync)
);

leds_set LEDS(
    .COLOR_NUM(final_COLOR_NUM),
    .led(led)
);

endmodule