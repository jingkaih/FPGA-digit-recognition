`timescale 1ns / 1ps

module top(
    clk, rst_n, uart_rx, sclk, rclk, s_data, led_img_saved
    );
    input clk;
    input rst_n;

    input uart_rx;
    output wire sclk;
    output wire rclk;
    output wire s_data;
    
    
    wire img_saved;
    output reg led_img_saved;//indicate the successful storing of the first image
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            led_img_saved <= 0;
        else if(img_saved)
            led_img_saved <= 1;
        else
            led_img_saved <= led_img_saved;
    end
    





    wire [783:0] x;
    wire x_is_ready;
    from_uart_to_Layer1 from_uart_to_Layer1_inst(
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .x(x),
        .ready_to_compute(x_is_ready),
        .img_saved(img_saved)
    );

    wire [511:0] a1;
    wire a1_compute_Done;
    compute_a1 compute_a1_inst(
        .clk(clk),
        .rst_n(rst_n),
        .run_EN(x_is_ready),
        .x(x),
        .a1(a1),
        .a1_compute_Done(a1_compute_Done)
    );

    wire [511:0] a2;
    wire a2_compute_Done;
    compute_a2 compute_a2_inst(
        .clk(clk),
        .rst_n(rst_n),
        .run_EN(a1_compute_Done),
        .a1(a1),
        .a2(a2),
        .a2_compute_Done(a2_compute_Done)
    );

    wire [9:0] a3;
    wire a3_compute_Done;
    compute_a3 compute_a3_inst(
        .clk(clk),
        .rst_n(rst_n),
        .run_EN(a2_compute_Done),
        .a2(a2),
        .a3(a3),
        .a3_compute_Done(a3_compute_Done)
    );


    display display_inst(
        .clk(clk),
        .rst_n(rst_n),
        .digit(a3),
        .rclk(rclk),
        .sclk(sclk),
        .s_data(s_data),
        .display_EN(a3_compute_Done)
    );



endmodule
