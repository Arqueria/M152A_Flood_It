module btn_deb(
    input wire CLOCK,
    input wire btnC,
    input wire btnR,
    input wire btnL,
    input wire btnU,
    input wire btnD,
    output reg BTNC,
    output reg BTNR,
    output reg BTNL,
    output reg BTNU,
    output reg BTND
);

always @ (posedge CLOCK)
begin
	BTNC <= btnC;
	BTNR <= btnR;
	BTNL <= btnL;
	BTNU <= btnU;
	BTND <= btnD;
end

endmodule