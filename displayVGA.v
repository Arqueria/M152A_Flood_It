module displayVGA(
    input wire CLOCK,
    input wire [2:0] BOARD [25:0][25:0], 
    input wire [4:0] SIZE,
    input wire INITIALIZED,
    
    output reg [3:0] vgaRed,
    output reg [3:0] vgaBlue,
    output reg [3:0] vgaGreen,
    output wire Hsync,
    output wire Vsync
);

    parameter hpixels = 800;
    parameter vlines  = 521;
    parameter hpulse  = 96;
    parameter vpulse  = 2;
    parameter hbp     = 144;
    parameter vbp     = 31;  

    reg [9:0] hc;
    reg [9:0] vc;
    
    always @(posedge CLOCK) begin
        if (hc < hpixels - 1) hc <= hc + 1;
        else begin
            hc <= 0;
            if (vc < vlines - 1) vc <= vc + 1;
            else vc <= 0;
        end
    end
    
    assign Hsync = (hc < hpulse) ? 0 : 1;
    assign Vsync = (vc < vpulse) ? 0 : 1;
    
    localparam SQUARE_SIZE = 16;
    
    reg [10:0] dynamic_offset_x;
    reg [10:0] dynamic_offset_y;
    
    wire [10:0] board_width_px;
    wire [10:0] board_height_px;
    
    assign board_width_px  = SIZE * SQUARE_SIZE;
    assign board_height_px = SIZE * SQUARE_SIZE;
    
    always @(*) begin
        dynamic_offset_x = hbp + ((640 - board_width_px) >> 1);
        dynamic_offset_y = vbp + ((480 - board_height_px) >> 1);
    end

    wire [10:0] pixel_x;
    wire [10:0] pixel_y;
    assign pixel_x = hc; 
    assign pixel_y = vc;
    
    wire [5:0] grid_col;
    wire [5:0] grid_row;
    
    assign grid_col = (pixel_x >= dynamic_offset_x) ? (pixel_x - dynamic_offset_x) / SQUARE_SIZE : 6'd63;
    assign grid_row = (pixel_y >= dynamic_offset_y) ? (pixel_y - dynamic_offset_y) / SQUARE_SIZE : 6'd63;
    
    always @(*) begin
        if (INITIALIZED) begin
            if (pixel_x >= hbp && pixel_x < (hbp + 640) && pixel_y >= vbp && pixel_y < (vbp + 480)) begin
                
                if (pixel_x >= dynamic_offset_x && pixel_y >= dynamic_offset_y && 
                    grid_col < SIZE && grid_row < SIZE) begin
                    
                    case (BOARD[grid_row][grid_col])
                        3'd0: begin vgaRed = 4'hF; vgaGreen = 4'h0; vgaBlue = 4'h0; end
                        3'd1: begin vgaRed = 4'h0; vgaGreen = 4'hF; vgaBlue = 4'h0; end
                        3'd2: begin vgaRed = 4'h0; vgaGreen = 4'h0; vgaBlue = 4'hF; end
                        3'd3: begin vgaRed = 4'hF; vgaGreen = 4'hF; vgaBlue = 4'h0; end
                        3'd4: begin vgaRed = 4'h0; vgaGreen = 4'hF; vgaBlue = 4'hF; end
                        3'd5: begin vgaRed = 4'hF; vgaGreen = 4'h0; vgaBlue = 4'hF; end
                        3'd6: begin vgaRed = 4'hF; vgaGreen = 4'h8; vgaBlue = 4'h0; end
                        3'd7: begin vgaRed = 4'hF; vgaGreen = 4'hF; vgaBlue = 4'hF; end
                        default: begin vgaRed = 0; vgaGreen = 0; vgaBlue = 0; end
                    endcase
                    
                end else begin
                    vgaRed = 0; vgaBlue = 0; vgaGreen = 0;
                end
                
            end else begin
                vgaRed = 0; vgaBlue = 0; vgaGreen = 0;
            end
        end else begin
            vgaRed = 0; vgaBlue = 0; vgaGreen = 0;
        end
    end
    
    
endmodule