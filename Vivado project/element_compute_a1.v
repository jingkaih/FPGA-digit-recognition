`timescale 1ns / 1ps

//This module was designed to compute a single element of a1 vector, call this module 512 times you can get a a1 vector of size 512.
//In our BNN implementation, the input image is a 784 bits long 0/1 vector x.
//The 1s are of course 1 while doing dot multiply with w1, and the 0s are considered as real 0 which will make the product of itself all 0s.
//Note that this is unlike the 0s in either w1, w2, w3 and a1, a2, a3 where those 0s represent -1 in the real world.
//Thus we can't use XNOR-popcount. We need a new computing unit.

module element_compute_a1#(parameter WIDTH=10'd784)(//方法1，统计按位AND后的foo vector中的0的个数，注意这里的0真假混杂。再统计x中0的个数，注意这里全为真0。做减法得到假0（实为-1）个数，
                          //然后之前知道了foo vector中0的个数，用WITDH=784减去该个数可以得到1的个数，比较1的个数和假0个数即可
    row_vector, col_vector, dot_product_0_1
    );
    input [WIDTH-1:0] row_vector;//a row of w1
    input [WIDTH-1:0] col_vector;//x
    output reg dot_product_0_1;

    //AND operation
    //think of it a mask operation
    wire [WIDTH-1:0] foo;
    assign foo = row_vector & col_vector;
    //Since now our foo vector has 2 types of 0: "0 representing -1" and "real 0"
    //In order to differentiate them.
    //count the number of 0s in x, in other words, the "real 0"s.
    //count the number of 0s in foo
    reg [9:0] count_zeros_in_x;
    reg [9:0] count_zeros_in_f;
    reg [9:0] count_ones_in_f;
    reg [9:0] count_minus1_in_f;
    integer i;
    always @(*) begin
        count_zeros_in_x = {10{1'b0}};
        count_zeros_in_f = {10{1'b0}};
        count_ones_in_f = {10{1'b0}};
        count_minus1_in_f = {10{1'b0}};
        for(i = 0; i < WIDTH; i = i + 1) begin
            count_zeros_in_x = count_zeros_in_x + !col_vector[i];
            count_zeros_in_f = count_zeros_in_f + !foo[i];
        end
        count_ones_in_f = WIDTH - count_zeros_in_f;
        count_minus1_in_f = count_zeros_in_f - count_zeros_in_x;
        if(count_ones_in_f >= count_minus1_in_f)
            dot_product_0_1 = 1;
        else
            dot_product_0_1 = 0;
    end

endmodule


//还有一种不使用减法的求假零数量的方法：
//There's another way to count fake_zeros without introducing any minus operation
//可以使用xor和加法来代替减法
//use XOR and ADD
//首先foo = row_vector & col_vector
//First let foo = row_vector & col_vector
//其中row为w，col为x
//where row is w and col is x
//再var = foo xor col_vector
//Then do bitwise XOR, i.e. let var = foo ^ col_vector
//N中1的个数即为foo_vector中假0(minus1)的个数

    // reg [783:0] var;
    // reg [9:0] count_fake_zeros;
    // integer j;
    // always @(*) begin
    //     count_fake_zeros = 0;
    //     var = foo^col_vector;
    //     count_fake_zeros = 0;
    //     for(j = 0; j < 784; j = j + 1) begin
    //         count_fake_zeros = count_fake_zeros + var[j];
    //     end
    // end