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

select selector(
    .MASTER_CLOCK(HZ1000),
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
    .INITIALIZED(),
    .COLOR_SEL_SIG(),
    .COLOR_SELECTED(),
    .BEGIN_GAME(),
    .ACK_BEGIN_GAME(),
    .SIZE(),
    .COLOR_NUM(),

    // digit and led displays
    .MODE(),
    .TRIES(),
    .TOTAL_TRIES(),
    .final_SIZE(),
    .final_COLOR_NUM(),
    .sORc()
);

rand random_gen(



);

digit_display digdisp(


);




endmodule