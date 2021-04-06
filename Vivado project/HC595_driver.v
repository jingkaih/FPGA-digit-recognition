`timescale 1ns / 1ps

//74HC595 driver
//parallel to serial

module HC595_driver(
    clk, rst_n, p_data, s_data, sclk, rclk
    );

    input wire clk;
    input wire rst_n;
    input wire [15:0] p_data;//p_data[15:8] = seg[7:0], p_data[7:0] = sel[7:0]


    output wire sclk;//74HC595 read 1 bit from serial port (s_data) every posedge of sclk. Frequency should be 12.5MHz according to datasheet.
    //for successful reading, 1bit data need to stay still until the next posedge of sclk come, the only time we can change it is while in the vicinity of negedge.
    output reg s_data;//serial data output
    output reg rclk;//save bits and output to the parallel port at rclk's posedge(impulse)


    

    //clk_divider: 50MHz to 12.5MHz
    reg [1:0] divider_cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            divider_cnt <= 0;
        else if(divider_cnt == 3)
            divider_cnt <= 0;
        else
            divider_cnt <= divider_cnt + 1;
    end

    assign sclk = (divider_cnt == 1 | divider_cnt == 2)?1:0;
    

    wire sclk_impulse;
    assign sclk_impulse = (divider_cnt == 1);

    reg [4:0] sclk_impulse_cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            sclk_impulse_cnt <= 0;
        else if(sclk_impulse_cnt == 17)
            sclk_impulse_cnt <= 0;
        else if(sclk_impulse == 1)
            sclk_impulse_cnt <= sclk_impulse_cnt + 1;
        else
            sclk_impulse_cnt <= sclk_impulse_cnt;
    end




    always @(*) begin
        case (sclk_impulse_cnt)
            0: begin
                rclk <= 1;
                s_data <= 1;
            end
            1: begin
                rclk <= 0;
                s_data <= p_data[15];
            end
            2: begin
                rclk <= 0;
                s_data <= p_data[14];
            end
            3: begin
                rclk <= 0;
                s_data <= p_data[13];
            end
            4: begin
                rclk <= 0;
                s_data <= p_data[12];
            end
            5: begin
                rclk <= 0;
                s_data <= p_data[11];
            end
            6: begin
                rclk <= 0;
                s_data <= p_data[10];
            end
            7: begin
                rclk <= 0;
                s_data <= p_data[9];
            end
            8: begin
                rclk <= 0;
                s_data <= p_data[8];
            end
            9: begin
                rclk <= 0;
                s_data <= p_data[7];
            end
            10: begin
                rclk <= 0;
                s_data <= p_data[6];
            end
            11: begin
                rclk <= 0;
                s_data <= p_data[5];
            end
            12: begin
                rclk <= 0;
                s_data <= p_data[4];
            end
            13: begin
                rclk <= 0;
                s_data <= p_data[3];
            end
            14: begin
                rclk <= 0;
                s_data <= p_data[2];
            end
            15: begin
                rclk <= 0;
                s_data <= p_data[1];
            end
            16: begin
                rclk <= 0;
                s_data <= p_data[0];
            end
            17: begin
                rclk <= 1;
                s_data <= 1;
            end
            default: begin
                rclk <= 0;
                s_data <= 1;
            end    
        endcase
    end


endmodule
