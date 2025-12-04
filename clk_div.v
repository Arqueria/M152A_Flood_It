module clk_div(
    input wire clk, // 100 MHz
    output reg HZ1 = 0,
    output reg HZ4 = 0,
    output reg HZ5 = 0,
    output reg HZ8 = 0,
    output reg HZ500 = 0,
    output reg HZ1000 = 0,
    output reg HZ5K = 0,
    output reg HZ10K = 0,
    output reg MHZ25 = 0,
    output reg MHZ50 = 0
);

integer HZ1_COUNT = 0;
integer HZ4_COUNT = 0;
integer HZ5_COUNT = 0;
integer HZ8_COUNT = 0;
integer HZ500_COUNT = 0;
integer HZ1000_COUNT = 0;
integer HZ5K_COUNT = 0;
integer HZ10K_COUNT = 0;
integer MHZ25_COUNT = 0;
integer MHZ50_COUNT = 0;


always @ (posedge clk)
begin
    if(HZ1_COUNT < 50_000_000 - 1)
        begin
            HZ1_COUNT <= HZ1_COUNT + 1;
        end
    else
        begin
            HZ1_COUNT <= 0;
            HZ1 <= ~HZ1;
        end


    if(HZ4_COUNT < 12_500_000 - 1)
        begin
            HZ4_COUNT <= HZ4_COUNT + 1;
        end
    else
        begin
            HZ4_COUNT <= 0;
            HZ4 <= ~HZ4;
        end

    if(HZ5_COUNT < 10_000_000 - 1)
        begin
            HZ5_COUNT <= HZ5_COUNT + 1;
        end
    else
        begin
            HZ5_COUNT <= 0;
            HZ5 <= ~HZ5;
        end
        
    if(HZ8_COUNT < 6_250_000 - 1)
        begin
            HZ8_COUNT <= HZ8_COUNT + 1;
        end
    else
        begin
            HZ8_COUNT <= 0;
            HZ8 <= ~HZ8;
        end
        
    if(HZ500_COUNT < 100_000 - 1)
        begin
            HZ500_COUNT <= HZ500_COUNT + 1;
        end
    else
        begin
            HZ500_COUNT <= 0;
            HZ500 <= ~HZ500;
        end

    if(HZ1000_COUNT < 50_000 - 1)
        begin
            HZ1000_COUNT <= HZ1000_COUNT + 1;
        end
    else
        begin
            HZ1000_COUNT <= 0;
            HZ1000 <= ~HZ1000;
        end


    if(HZ5K_COUNT < 10_000 - 1)
        begin
            HZ5K_COUNT <= HZ5K_COUNT + 1;
        end
    else
        begin
            HZ5K_COUNT <= 0;
            HZ5K <= ~HZ5K;
        end

    

    if(HZ10K_COUNT < 5_000 - 1)
        begin
            HZ10K_COUNT <= HZ10K_COUNT + 1;
        end
    else
        begin
            HZ10K_COUNT <= 0;
            HZ10K <= ~HZ10K;
        end


    if(MHZ25_COUNT < 2 - 1)
        begin
            MHZ25_COUNT <= MHZ25_COUNT + 1;
        end
    else
        begin
            MHZ25_COUNT <= 0;
            MHZ25 <= ~MHZ25;
        end
    
    MHZ50 <= ~MHZ50;
end



endmodule