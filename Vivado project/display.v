`timescale 1ns / 1ps


module display(
    clk, rst_n, digit, rclk, sclk, s_data, display_EN
    );
    input clk;
    input rst_n;
    input [9:0] digit;
    input display_EN;
    output wire rclk;
    output wire sclk;
    output wire s_data;

    wire [15:0] p_data;

    HC595_driver this_driver(
        .clk(clk),
        .rst_n(rst_n),
        .p_data(p_data),
        .s_data(s_data),
        .sclk(sclk),
        .rclk(rclk)
    );


    reg display_EN_last_long;
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            display_EN_last_long <= 0;
        else if(display_EN)
            display_EN_last_long <= 1;
        else
            display_EN_last_long <= display_EN_last_long;
    end

    reg [7:0] seg;
    assign p_data = {seg,8'b0000_0001};//p_data[15:8] = seg[7:0], p_data[7:0] = sel[7:0]

    always @(*) begin
        if(display_EN_last_long) begin
            case (digit)
            10'b1000000000: seg = 8'b11000000;//0
            10'b0100000000: seg = 8'b11111001;//1
            10'b0010000000: seg = 8'b10100100;//2
            10'b0001000000: seg = 8'b10110000;//3
            10'b0000100000: seg = 8'b10011001;//4
            10'b0000010000: seg = 8'b10010010;//5
            10'b0000001000: seg = 8'b10000010;//6
            10'b0000000100: seg = 8'b11111000;//7
            10'b0000000010: seg = 8'b10000000;//8
            10'b0000000001: seg = 8'b10010000;//9
            default: seg = 8'b11111111;
        endcase
        end
        else
            seg = 8'b11111111;

    end
endmodule
