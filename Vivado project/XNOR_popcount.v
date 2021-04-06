`timescale 1ns / 1ps
//ref: https://sushscience.wordpress.com/2017/10/01/understanding-binary-neural-networks/


//this is to implement a base step of np.dot(a1, L2_weights) and the Binary activation is also done
module XNOR_popcount#(parameter WIDTH=512)(//
    
    row_vector, col_vector, dot_product_0_1
    );
    input [WIDTH-1:0] row_vector;
    input [WIDTH-1:0] col_vector;
    output wire dot_product_0_1;//output either 0 or 1 where 1 stands for 1 and 0 stands for -1.
                                //0 should be -1 for real computation like floating in PC. Here we just use 0 to denote -1.
    reg [9:0] count_ones;
    wire [WIDTH-1:0] xnor_vector;

    //do XNOR
    assign xnor_vector = row_vector~^col_vector;
    //count the numbers of 1 in XNOR outcome
    integer i;
    always @(*) begin
        count_ones = {10{1'b0}};
        for(i = 0; i < WIDTH; i = i + 1) begin
            count_ones = count_ones + xnor_vector[i];
        end
    end

    //XNOR popcount algorithm as well as Binary activation function
    assign dot_product_0_1 = (2*count_ones >= WIDTH)?1'b1:1'b0;//where 1'b0 stands for -1 in real computation


endmodule
