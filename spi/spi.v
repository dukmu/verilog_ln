//###########################//
//# author: xflcount@163.com
//# 2021-11-21 23:43 BeiJing
//# language: verilog
//# description:
//#	spi_module, 8bits
//###########################//

`timescale 1ns/1ps
module spi_module_master
(
	input CLOCK, RESET, //positive_RESET, positive_CLOCK_50MHz
	input I_rx_en, //read_enabled signal
	input I_tx_en, //write_enabled signal
	output reg [7:0] iData, //master input
	input [7:0] oData, //master output
	output reg iDone, //master input
	output reg oDone, //master output
	
	/*
	IDLE = CPOL^CPHA
	RECEIVE_EDGE = IDLE? negdge:posedge
	*/
	input CPOL,
	input CPHA,

	//standarded four-wire spi_bus
	input I_spi_miso, //master input slave output
	output reg O_spi_sck, //clock of spi
	output reg O_spi_cs, //chip selected, positive
	output reg O_spi_mosi //master output slave input
);
reg delay;
reg[2:0] r_rx_index;
reg[2:0] r_tx_index;

always@(posedge CLOCK or posedge RESET) begin
	if(RESET) begin
		iData<=8'd0;
		iDone<=1'b0;
		oDone<=1'b0;
		O_spi_cs<=1'b0; //is that correct?
		O_spi_sck<=CPOL;
		O_spi_mosi<=1'b0;
		r_rx_index<=3'd7;
		r_tx_index<=3'd7;
		delay<=CPHA;
		$display("RESET master");
	end
	else begin
		if(I_rx_en&&(O_spi_sck==CPOL^CPHA)) begin
			if(delay) begin
				iDone<=1'b0;
				iData[r_rx_index]<=I_spi_miso;
				r_rx_index<=r_rx_index+3'd7;
				if(r_rx_index==3'd0) begin
					iDone<=1'b1;
				end
			end
			else begin
				delay<=1'b1;
			end
		end
		if(I_tx_en&&!(O_spi_sck==CPOL^CPHA)) begin
			oDone<=1'b0;
			O_spi_mosi<=oData[r_tx_index];
			r_tx_index<=r_tx_index+3'd7;
			if(r_tx_index==3'd0) begin
				oDone<=1'b1;
			end
		end
		if(I_rx_en||I_tx_en) begin
			O_spi_sck<=~O_spi_sck;
			O_spi_cs<=1'b1;
		end
		else begin
			O_spi_cs<=1'b0;
		end
	end
end
endmodule

/**************************************************************/
/**************************************************************/

module spi_module_slave
(
	input RESET, //positive_RESET, positive_CLOCK_50MHz
	input I_rx_en, //read_enabled signal
	input I_tx_en, //write_enabled signal
	output reg [7:0] iData, //slave input
	input [7:0] oData, //slave output
	output reg iDone, //slave input
	output reg oDone, //slave output
	
	/*
	IDLE = CPOL^CPHA
	RECEIVE_EDGE = IDLE? negdge:posedge
	*/
	input CPOL,
	input CPHA,

	//standarded four-wire spi_bus
	output reg O_spi_miso, //master input slave output
	input I_spi_sck, //clock of spi
	input I_spi_cs, //chip selected, positive_
	input I_spi_mosi //master output slave input
);
reg delay;
reg[2:0] r_rx_index;
reg[2:0] r_tx_index;

always@(posedge I_spi_sck or posedge RESET) begin
	if(RESET) begin
		iData<=8'd0;
		iDone<=1'b0;
		oDone<=1'b0;
		O_spi_miso<=1'b0;
		r_rx_index<=3'd7;
		r_tx_index<=3'd7;
		delay<=CPHA;
	end
	else begin
	if(I_spi_cs==1'b1) begin
		if(I_rx_en&&(CPOL^CPHA==1'b0)) begin
			if(delay) begin
				iDone<=1'b0;
				iData[r_rx_index]<=I_spi_mosi;
				r_rx_index<=r_rx_index+3'd7;
				if(r_rx_index==3'd0) begin
					iDone<=1'b1;
				end
			end
			else begin
				delay<=1'b1;
			end
		end
		if(I_tx_en&&!(CPOL^CPHA==1'b0)) begin
			oDone<=1'b0;
			O_spi_miso<=oData[r_tx_index];
			r_tx_index<=r_tx_index+3'd7;
			if(r_tx_index==3'd0) begin
				oDone<=1'b1;
			end
		end
	end
	end
end
always@(negedge I_spi_sck or posedge RESET) begin
	if(RESET) begin
		iData<=8'd0;
		iDone<=1'b0;
		oDone<=1'b0;
		O_spi_miso<=1'b0;
		r_rx_index<=3'd7;
		r_tx_index<=3'd7;
		delay<=CPHA;
	end
	else begin
	if(I_spi_cs==1'b1) begin
		if(I_rx_en&&(CPOL^CPHA==1'b1)) begin
			if(delay) begin
				iDone<=1'b0;
				iData[r_rx_index]<=I_spi_mosi;
				r_rx_index<=r_rx_index+3'd7;
				if(r_rx_index==3'd0) begin
					iDone<=1'b1;
				end
			end
			else begin 
				delay<=1'b1;
			end
		end
		if(I_tx_en&&!(CPOL^CPHA==1'b1)) begin
			oDone<=1'b0;
			O_spi_miso<=oData[r_tx_index];
			r_tx_index<=r_tx_index+3'd7;
			if(r_tx_index==3'd0) begin
				oDone<=1'b1;
			end
		end
	end
	end
end
endmodule