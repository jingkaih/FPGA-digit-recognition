`timescale 1ns / 1ps


module compute_a3(
    clk, rst_n, run_EN, a2, a3, a3_compute_Done
    );

    input clk;
    input rst_n;
    input run_EN;//enable computing impulse. This should be connected to "compute_a2.a2_compute_Done" in higher level module

    output reg [9:0] a3;//a1 is a 10 bits long vector, 1 is 1, 0 is -1
    output reg a3_compute_Done;//compute done

    input [511:0] a2;//a1 should be connected to "compute_a1" in higher level module

    
    reg [3:0] addra;//addra ranges from 0 to 9
    wire [511:0] one_row;

    rom_w3_transpose w3_weights(
        .clka(clk),
        .addra(addra),
        .douta(one_row)
    );

    reg addra_add_EN;
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            addra_add_EN <= 0;
        else if(run_EN)
            addra_add_EN <= 1;
        else if(addra == 11)//9
            addra_add_EN <= 0;
        else
            addra_add_EN <= addra_add_EN;
    end
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            addra <= 0;
        else if(addra_add_EN)
            addra <= addra + 1;
        else if(addra == 11)//9
            addra <= 0;
        else
            addra <= 0;
    end

    wire dot_product_0_1;
    XNOR_popcount#(.WIDTH(512)) XNOR_popcount_inst(
        .row_vector(one_row),
        .col_vector(a2),
        .dot_product_0_1(dot_product_0_1)
    );

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            a3 <= 0;
        else if(addra_add_EN) begin
            case (addra)
                0,1,2 : a3[ 9 ] <= dot_product_0_1;
                3 : a3[ 8 ] <= dot_product_0_1;
                4 : a3[ 7 ] <= dot_product_0_1;
                5 : a3[ 6 ] <= dot_product_0_1;
                6 : a3[ 5 ] <= dot_product_0_1;
                7 : a3[ 4 ] <= dot_product_0_1;
                8 : a3[ 3 ] <= dot_product_0_1;
                9 : a3[ 2 ] <= dot_product_0_1;
                10 : a3[ 1 ] <= dot_product_0_1;
                11 : a3[ 0 ] <= dot_product_0_1;
            endcase
        end
    end


    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)
            a3_compute_Done <= 0;
        else if(addra == 11)
            a3_compute_Done <= 1;
        else
            a3_compute_Done <= 0;
    end
endmodule
