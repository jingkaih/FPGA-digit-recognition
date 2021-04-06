`timescale 1ns / 1ps

//uart receive module
//baud rate = 9600 if baud_set = 0 

module uart_rx(
	clk,
	rst_n,

	baud_set,
	uart_rx,

	data_byte,
	rx_done
);
	assign reset=~rst_n;

	input clk;
	input rst_n;

	input [2:0]baud_set;
	input uart_rx;
	
	output [7:0]data_byte;
	output rx_done;
	
	reg [7:0]data_byte;
	reg rx_done;
	reg uart_rx_sync1;
	reg uart_rx_sync2;

	reg uart_rx_reg1;
	reg uart_rx_reg2;

	reg [15:0]bps_DR;
	reg [15:0]div_cnt;
	reg bps_clk;
	reg [7:0] bps_cnt;
	reg uart_state;

	wire uart_rx_nedge;  

	reg [2:0]START_BIT;
	reg [2:0]STOP_BIT;
	reg [2:0]data_byte_pre [7:0];


	always@(posedge clk or posedge reset)
	if(reset)begin
		uart_rx_sync1 <= 1'b0;
		uart_rx_sync2 <= 1'b0;	
	end
	else begin
		uart_rx_sync1 <= uart_rx;
		uart_rx_sync2 <= uart_rx_sync1;	
	end
	

	always@(posedge clk or posedge reset)
	if(reset)begin
		uart_rx_reg1 <= 1'b0;
		uart_rx_reg2 <= 1'b0;	
	end
	else begin
		uart_rx_reg1 <= uart_rx_sync2;
		uart_rx_reg2 <= uart_rx_reg1;	
	end
	

	assign uart_rx_nedge = !uart_rx_reg1 & uart_rx_reg2;
	
	always@(posedge clk or posedge reset)
	if(reset)
		bps_DR <= 16'd324;
	else begin
		case(baud_set)
			0:bps_DR <= 16'd324;
			1:bps_DR <= 16'd162;
			2:bps_DR <= 16'd80;
			3:bps_DR <= 16'd53;
			4:bps_DR <= 16'd26;
			default:bps_DR <= 16'd324;			
		endcase
	end
	

	always@(posedge clk or posedge reset)
	if(reset)
		div_cnt <= 16'd0;
	else if(uart_state)begin
		if(div_cnt == bps_DR)
			div_cnt <= 16'd0;
		else
			div_cnt <= div_cnt + 1'b1;
	end
	else
		div_cnt <= 16'd0;
		

	always@(posedge clk or posedge reset)
	if(reset)
		bps_clk <= 1'b0;
	else if(div_cnt == 16'd1)
		bps_clk <= 1'b1;
	else
		bps_clk <= 1'b0;
	

	always@(posedge clk or posedge reset)
	if(reset)	
		bps_cnt <= 8'd0;
	else if(bps_cnt == 8'd159 | (bps_cnt == 8'd12 && (START_BIT > 2)))
		bps_cnt <= 8'd0;
	else if(bps_clk)
		bps_cnt <= bps_cnt + 1'b1;
	else
		bps_cnt <= bps_cnt;

	always@(posedge clk or posedge reset)
	if(reset)
		rx_done <= 1'b0;
	else if(bps_cnt == 8'd159)
		rx_done <= 1'b1;
	else
		rx_done <= 1'b0;		
		
	always@(posedge clk or posedge reset)
	if(reset)begin
		START_BIT <= 3'd0;
		data_byte_pre[0] <= 3'd0;
		data_byte_pre[1] <= 3'd0;
		data_byte_pre[2] <= 3'd0;
		data_byte_pre[3] <= 3'd0;
		data_byte_pre[4] <= 3'd0;
		data_byte_pre[5] <= 3'd0;
		data_byte_pre[6] <= 3'd0;
		data_byte_pre[7] <= 3'd0;
		STOP_BIT <= 3'd0;
	end
	else if(bps_clk)begin
		case(bps_cnt)
			0:begin
        START_BIT <= 3'd0;
        data_byte_pre[0] <= 3'd0;
        data_byte_pre[1] <= 3'd0;
        data_byte_pre[2] <= 3'd0;
        data_byte_pre[3] <= 3'd0;
        data_byte_pre[4] <= 3'd0;
        data_byte_pre[5] <= 3'd0;
        data_byte_pre[6] <= 3'd0;
        data_byte_pre[7] <= 3'd0;
        STOP_BIT <= 3'd0;			
      end
			6 ,7 ,8 ,9 ,10,11:START_BIT <= START_BIT + uart_rx_sync2;					//Check uart_rx 16 times during a single bit long period
																						//But we only pick the 6 observations at the middle of a bit's transmission
			22,23,24,25,26,27:data_byte_pre[0] <= data_byte_pre[0] + uart_rx_sync2;		//then see how likely this bit is a 1 or 0
			38,39,40,41,42,43:data_byte_pre[1] <= data_byte_pre[1] + uart_rx_sync2;		//decide it by comparing the data_byte_pre of each bit 
			54,55,56,57,58,59:data_byte_pre[2] <= data_byte_pre[2] + uart_rx_sync2;		//with 0,1,2,3 in which case are all 3'b0xx, or 4,5,6 in which case 3'1xx
			70,71,72,73,74,75:data_byte_pre[3] <= data_byte_pre[3] + uart_rx_sync2;		//By extracting the MSB of data_byte_pre, we decide this bit to be a 1 or 0
			86,87,88,89,90,91:data_byte_pre[4] <= data_byte_pre[4] + uart_rx_sync2;
			102,103,104,105,106,107:data_byte_pre[5] <= data_byte_pre[5] + uart_rx_sync2;
			118,119,120,121,122,123:data_byte_pre[6] <= data_byte_pre[6] + uart_rx_sync2;
			134,135,136,137,138,139:data_byte_pre[7] <= data_byte_pre[7] + uart_rx_sync2;
			150,151,152,153,154,155:STOP_BIT <= STOP_BIT + uart_rx_sync2;
			default:
      begin
        START_BIT <= START_BIT;
        data_byte_pre[0] <= data_byte_pre[0];
        data_byte_pre[1] <= data_byte_pre[1];
        data_byte_pre[2] <= data_byte_pre[2];
        data_byte_pre[3] <= data_byte_pre[3];
        data_byte_pre[4] <= data_byte_pre[4];
        data_byte_pre[5] <= data_byte_pre[5];
        data_byte_pre[6] <= data_byte_pre[6];
        data_byte_pre[7] <= data_byte_pre[7];
        STOP_BIT <= STOP_BIT;
      end
		endcase
	end

	always@(posedge clk or posedge reset)
	if(reset)
		data_byte <= 8'd0;
	else if(bps_cnt == 8'd159)begin
		data_byte[0] <= data_byte_pre[0][2];
		data_byte[1] <= data_byte_pre[1][2];
		data_byte[2] <= data_byte_pre[2][2];
		data_byte[3] <= data_byte_pre[3][2];
		data_byte[4] <= data_byte_pre[4][2];
		data_byte[5] <= data_byte_pre[5][2];
		data_byte[6] <= data_byte_pre[6][2];
		data_byte[7] <= data_byte_pre[7][2];
	end	
	
	always@(posedge clk or posedge reset)
	if(reset)
		uart_state <= 1'b0;
	else if(uart_rx_nedge)
		uart_state <= 1'b1;
	else if(rx_done || (bps_cnt == 8'd12 && (START_BIT > 2)) || (bps_cnt == 8'd155 && (STOP_BIT < 3)))//consider invalid start bit and stop bit
		uart_state <= 1'b0;
	else
		uart_state <= uart_state;		

endmodule