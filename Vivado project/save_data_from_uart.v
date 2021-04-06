`timescale 1ns / 1ps

//this module is able to convert 8-bit value to 1-bit ZERO or ONE through binarization
//the aim is to turn a white(8'd0)-gray(something between 0 to 255)-black(8'd255) image to a simple white(1'b0)-black(1'b1) image
//thus there will be a lot memory saving

module save_data_from_uart(
    clk, rst_n, uart_rx, addrb, doutb_observe, a_row_saved_done, img_saved, pixel_cnt
    );

    input clk;//from the outside
    input rst_n;//from the outside
    input uart_rx;//from the outside


    wire rx_done;
    wire [7:0] data_byte;//data_byte和rx_done同时刻跳，rx_done持续一个clk

    uart_rx myuart_rx(
        .clk(clk),
        .rst_n(rst_n),
        .uart_rx(uart_rx),
        .baud_set(3'd0),
        .rx_done(rx_done),
        .data_byte(data_byte)
    );

    reg rx_done_reg;
    always @(posedge clk ,negedge rst_n) begin
        if(!rst_n)
            rx_done_reg <= 0;
        else
            rx_done_reg <= rx_done;
    end

    //binarize
    reg bits_to_bit;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            bits_to_bit <= 0;
        else if(rx_done) begin
            if(data_byte == 8'd0)
                bits_to_bit <= 0;//0: white is white;
            else                 //1,2,3,...,254: gray is black;
                bits_to_bit <= 1;//255: black is black;
        end                      
        else
            bits_to_bit <= bits_to_bit;
    end

    output reg [9:0] pixel_cnt;//28*28=784 pixels
    reg [9:0] pixel_cnt_delay;
    reg [9:0] pixel_cnt_delay2;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            pixel_cnt <= 0;
        else if(rx_done) begin
            if(pixel_cnt == 784)
                pixel_cnt <= 1;
            else
                pixel_cnt <= pixel_cnt + 1;
        end
        else
            pixel_cnt <= pixel_cnt;
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            pixel_cnt_delay <= 0;
            pixel_cnt_delay2 <= 0;            
        end
        else begin
            pixel_cnt_delay <= pixel_cnt;
            pixel_cnt_delay2 <= pixel_cnt_delay;            
        end
    end




    output wire a_row_saved_done;



    //once a full image ends its transmission, generate an impluse
    reg img_saved_last_long;
    reg img_saved_last_long_reg;
    output wire img_saved;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            img_saved_last_long <= 0;
        else if(pixel_cnt_delay2 == 784)//after 784 rx_done came, everything ends
            img_saved_last_long <= 1;
        else
            img_saved_last_long <= 0;
    end

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            img_saved_last_long_reg <= 0;
        else
            img_saved_last_long_reg <= img_saved_last_long;
    end

    assign img_saved = img_saved_last_long && !img_saved_last_long_reg;


    reg [27:0] dina;
    wire [27:0] doutb;
    reg [4:0] addra;//depth = 32, we only use 28
    input [4:0] addrb;//depth = 32, we only use 28

    reg wea_last_long;


    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            addra <= 5'd0;
            wea_last_long <= 0;
            dina <= 28'b0000_0000_0000_0000_0000_0000_0000;//dina[27:0] = {dina[27:1], dina[0]}
        end
        else if(rx_done_reg) begin
            case (pixel_cnt)
                0: begin
                    addra <= 5'd0;
                    wea_last_long <= 0;
                end

                1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                28: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd0;
                        wea_last_long <= 1;
                end
                29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                56: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd1;
                        wea_last_long <= 1;
                end
                57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                84: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd2;
                        wea_last_long <= 1;
                end
                85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                112: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd3;
                        wea_last_long <= 1;
                end
                113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                140: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd4;
                        wea_last_long <= 1;
                end
                141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                168: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd5;
                        wea_last_long <= 1;
                end
                169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                196: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd6;
                        wea_last_long <= 1;
                end
                197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                224: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd7;
                        wea_last_long <= 1;
                end
                225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                252: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd8;
                        wea_last_long <= 1;
                end
                253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                280: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd9;
                        wea_last_long <= 1;
                end
                281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                308: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd10;
                        wea_last_long <= 1;
                end
                309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                336: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd11;
                        wea_last_long <= 1;
                end
                337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                364: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd12;
                        wea_last_long <= 1;
                end
                365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                392: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd13;
                        wea_last_long <= 1;
                end
                393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                420: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd14;
                        wea_last_long <= 1;
                end
                421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                448: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd15;
                        wea_last_long <= 1;
                end
                449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                476: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd16;
                        wea_last_long <= 1;
                end
                477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                504: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd17;
                        wea_last_long <= 1;
                end
                505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                532: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd18;
                        wea_last_long <= 1;
                end
                533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                560: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd19;
                        wea_last_long <= 1;
                end
                561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                588: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd20;
                        wea_last_long <= 1;
                end
                589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                616: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd21;
                        wea_last_long <= 1;
                end
                617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                644: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd22;
                        wea_last_long <= 1;
                end
                645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                672: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd23;
                        wea_last_long <= 1;
                end
                673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                700: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd24;
                        wea_last_long <= 1;
                end
                701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                728: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd25;
                        wea_last_long <= 1;
                end
                729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                756: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd26;
                        wea_last_long <= 1;
                end
                757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783: begin
                        dina <= {dina[26:0], bits_to_bit};
                        wea_last_long <= 0;
                end
                784: begin
                        dina <= {dina[26:0], bits_to_bit};
                        addra <= 5'd27;
                        wea_last_long <= 1;
                end

                default: begin
                    dina <= dina;
                    addra <= addra;
                    wea_last_long <= 0;
                end
            endcase            
        end

    end

    wire wea;//write enable signal

    reg wea_last_long_reg;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            wea_last_long_reg <= 0;
        else
            wea_last_long_reg <= wea_last_long;
    end

    assign wea = wea_last_long && !wea_last_long_reg;


    assign a_row_saved_done = wea;


    blk_mem_gen_0 myram(
        .clka(clk),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .clkb(clk),
        .addrb(addrb),
        .doutb(doutb)
    );

    output reg [27:0] doutb_observe;
    always @(*) begin
        doutb_observe = doutb;
    end
    
endmodule























