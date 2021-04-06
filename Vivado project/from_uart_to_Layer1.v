`timescale 1ns / 1ps


//It's time to take 28 clk periods to shift data from RAM to vector x once there comes a img_saved
module from_uart_to_Layer1(
    clk, rst_n, uart_rx, x, ready_to_compute, img_saved
    );

    input clk;
    input rst_n;
    input uart_rx;//directly from PC
    output reg [783:0] x;//vectorize x
    output reg ready_to_compute;
    output wire img_saved;
    reg [4:0] addrb;
    reg [4:0] addrb_dly;
    reg [4:0] addrb_dly2;
    wire [27:0] doutb_observe;


    wire [9:0] pixel_cnt;
    save_data_from_uart MySave(
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .addrb(addrb),
        .doutb_observe(doutb_observe),
        .img_saved(img_saved),
        .a_row_saved_done(),
        .pixel_cnt(pixel_cnt)
    );
    

    reg addrb_add_EN;


    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            addrb_add_EN <= 0;
        else if(img_saved)
            addrb_add_EN <= 1;
        else if(addrb == 5'd27)
            addrb_add_EN <= 0;
        else
            addrb_add_EN <= addrb_add_EN;
    end

    reg addrb_add_EN_dly;
    reg addrb_add_EN_dly2;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            addrb_add_EN_dly <= 0;
            addrb_add_EN_dly2 <= 0;
        end
        else begin
            addrb_add_EN_dly <= addrb_add_EN;
            addrb_add_EN_dly2 <= addrb_add_EN_dly;
        end
            
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            addrb <= 5'd31;
        else if(addrb_add_EN) begin
            if(addrb == 5'd27)
                addrb <= 5'd31;
            else
                addrb <= addrb + 1;
        end
        else
            addrb <= 5'd31;
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            addrb_dly <= 0;
            addrb_dly2 <= 0;
        end
        else begin
            addrb_dly <= addrb;
            addrb_dly2 <= addrb_dly;
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            x = 0;
        else if(addrb_add_EN_dly2) begin
            case (addrb_dly2)
                0: x[783:756] = doutb_observe;
                1: x[755:728] = doutb_observe;
                2: x[727:700] = doutb_observe;
                3: x[699:672] = doutb_observe;
                4: x[671:644] = doutb_observe;
                5: x[643:616] = doutb_observe;
                6: x[615:588] = doutb_observe;
                7: x[587:560] = doutb_observe;
                8: x[559:532] = doutb_observe;
                9: x[531:504] = doutb_observe;
                10: x[503:476] = doutb_observe;
                11: x[475:448] = doutb_observe;
                12: x[447:420] = doutb_observe;
                13: x[419:392] = doutb_observe;
                14: x[391:364] = doutb_observe;
                15: x[363:336] = doutb_observe;
                16: x[335:308] = doutb_observe;
                17: x[307:280] = doutb_observe;
                18: x[279:252] = doutb_observe;
                19: x[251:224] = doutb_observe;
                20: x[223:196] = doutb_observe;
                21: x[195:168] = doutb_observe;
                22: x[167:140] = doutb_observe;
                23: x[139:112] = doutb_observe;
                24: x[111:84] = doutb_observe;
                25: x[83:56] = doutb_observe;
                26: x[55:28] = doutb_observe;
                27: x[27:0] = doutb_observe;
                default: x = x;
            endcase  
        end
        else
            x = x;
    end


    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            ready_to_compute <= 0;
        else if(addrb_dly2 == 27)
            ready_to_compute <= 1;
        else
            ready_to_compute <= 0;
    end


endmodule



// DISPOSE!!!
// `timescale 1ns / 1ps


// //当img_saved成功之后一个周期，ram已写完毕，花28个clk period把ram中的数据移位进x中
// module from_uart_to_Layer1(
//     clk, rst_n, uart_rx, x, ready_to_compute
//     );

//     input clk;
//     input rst_n;
//     input uart_rx;//directly from PC
//     output reg [783:0] x;//vectorize x
//     output reg ready_to_compute;
//     wire img_saved;
//     reg [4:0] addrb;//读地址
//     wire [27:0] doutb_observe;
//     //wire a_row_saved_done;
//     // reg [27:0] data [27:0];


//     save_data_from_uart MySave(
//         .clk(clk),
//         .rst_n(rst_n),
//         .uart_rx(uart_rx),
//         .addrb(addrb),
//         .doutb_observe(doutb_observe),
//         .img_saved(img_saved),//after 784 pixels, generate an impulse
//         .a_row_saved_done()
//     );
    
//     //addrb is a counter, it takes 28 clk period to add up to 27 and then return to 0. It becomes active when there's a img_saved signal coming.
//     reg addrb_add_EN;

//     always @(posedge clk, negedge rst_n) begin
//         if(!rst_n)
//             addrb_add_EN <= 0;
//         else if(img_saved)//新图全部save完了, addrb开始自加1
//             addrb_add_EN <= 1;
//         else if(addrb == 29)//27
//             addrb_add_EN <= 0;
//         else
//             addrb_add_EN <= addrb_add_EN;
//     end

//     always @(posedge clk, negedge rst_n) begin
//         if(!rst_n)
//             addrb <= 0;
//         else if(addrb_add_EN)
//             addrb <= addrb + 1;
//         else if(addrb == 29)//27
//             addrb <= 0;
//         else
//             addrb <= 0;
//     end


//     always @(posedge clk, negedge rst_n) begin
//         if(!rst_n)
//             x = 0;
//         else if(addrb_add_EN) begin
//             case (addrb)
//                 0,1,2: x[783:756] = doutb_observe;//this delay is due to the RAM output register
//                 3: x[755:728] = doutb_observe;
//                 4: x[727:700] = doutb_observe;
//                 5: x[699:672] = doutb_observe;
//                 6: x[671:644] = doutb_observe;
//                 7: x[643:616] = doutb_observe;
//                 8: x[615:588] = doutb_observe;
//                 9: x[587:560] = doutb_observe;
//                 10: x[559:532] = doutb_observe;
//                 11: x[531:504] = doutb_observe;
//                 12: x[503:476] = doutb_observe;
//                 13: x[475:448] = doutb_observe;
//                 14: x[447:420] = doutb_observe;
//                 15: x[419:392] = doutb_observe;
//                 16: x[391:364] = doutb_observe;
//                 17: x[363:336] = doutb_observe;
//                 18: x[335:308] = doutb_observe;
//                 19: x[307:280] = doutb_observe;
//                 20: x[279:252] = doutb_observe;
//                 21: x[251:224] = doutb_observe;
//                 22: x[223:196] = doutb_observe;
//                 23: x[195:168] = doutb_observe;
//                 24: x[167:140] = doutb_observe;
//                 25: x[139:112] = doutb_observe;
//                 26: x[111:84] = doutb_observe;
//                 27: x[83:56] = doutb_observe;
//                 28: x[55:28] = doutb_observe;
//                 29: x[27:0] = doutb_observe;
//                 // 0: x[783:756] = doutb_observe;
//                 // 1: x[755:728] = doutb_observe;
//                 // 2: x[727:700] = doutb_observe;
//                 // 3: x[699:672] = doutb_observe;
//                 // 4: x[671:644] = doutb_observe;
//                 // 5: x[643:616] = doutb_observe;
//                 // 6: x[615:588] = doutb_observe;
//                 // 7: x[587:560] = doutb_observe;
//                 // 8: x[559:532] = doutb_observe;
//                 // 9: x[531:504] = doutb_observe;
//                 // 10: x[503:476] = doutb_observe;
//                 // 11: x[475:448] = doutb_observe;
//                 // 12: x[447:420] = doutb_observe;
//                 // 13: x[419:392] = doutb_observe;
//                 // 14: x[391:364] = doutb_observe;
//                 // 15: x[363:336] = doutb_observe;
//                 // 16: x[335:308] = doutb_observe;
//                 // 17: x[307:280] = doutb_observe;
//                 // 18: x[279:252] = doutb_observe;
//                 // 19: x[251:224] = doutb_observe;
//                 // 20: x[223:196] = doutb_observe;
//                 // 21: x[195:168] = doutb_observe;
//                 // 22: x[167:140] = doutb_observe;
//                 // 23: x[139:112] = doutb_observe;
//                 // 24: x[111:84] = doutb_observe;
//                 // 25: x[83:56] = doutb_observe;
//                 // 26: x[55:28] = doutb_observe;
//                 // 27: x[27:0] = doutb_observe;
//             endcase  
//         end
//         else
//             x = x;
//     end


//     always @(posedge clk, negedge rst_n) begin
//         if(!rst_n)
//             ready_to_compute <= 0;
//         else if(addrb == 29)
//             ready_to_compute <= 1;
//         else
//             ready_to_compute <= 0;
//     end



//     vio_0 vio_0(
//         .clk(clk),
//         .probe_in0(x[783:756]),
//         .probe_in1(x[755:728]),
//         .probe_in2(x[727:700]),
//         .probe_in3(x[699:672]),
//         .probe_in4(x[671:644]),
//         .probe_in5(x[643:616]),
//         .probe_in6(x[615:588]),
//         .probe_in7(x[587:560]),
//         .probe_in8(x[559:532]),
//         .probe_in9(x[531:504]),
//         .probe_in10(x[503:476]),
//         .probe_in11(x[475:448]),
//         .probe_in12(x[447:420]),
//         .probe_in13(x[419:392]),
//         .probe_in14(x[391:364]),
//         .probe_in15(x[363:336]),
//         .probe_in16(x[335:308]),
//         .probe_in17(x[307:280]),
//         .probe_in18(x[279:252]),
//         .probe_in19(x[251:224]),
//         .probe_in20(x[223:196]),
//         .probe_in21(x[195:168]),
//         .probe_in22(x[167:140]),
//         .probe_in23(x[139:112]),
//         .probe_in24(x[111:84]),
//         .probe_in25(x[83:56]),
//         .probe_in26(x[55:28]),
//         .probe_in27(x[27:0])

//     );


// endmodule
