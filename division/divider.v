/*
Author: DUMU
Created at: 2021.12.17 22:44 BeiJing

loop gen:
	;dividend_window shift right 1 bit
	;merchant_window shift right 1 bit
	;remainder linked to buffer
	merchant_unit=dividend_window/divisor ;1 bit
	remainder_unit=dividend_window-divisor
	merchant={merchant, merchant_unit}
	remainder=remainder-remainder_unit
in dependence of divider_cell.v:divider_cell
*/
module divider #(parameter N=5, parameter M=3)
	(
		input CLK,
		input RESET, //source should be reg
		input EN, //source should be reg
		input [N-1:0] dividend, //source should be reg
		input [M-1:0] divisor, //source should be reg

		output ACK, //reg
		output [N-1:0] merchant, //reg
		output [M-1:0] remainder //reg
	);
	wire[M-1:0] out_in[N-1:0];
	wire CK[N-1:0];
	divider_cell #(.N(N), .M(M)) cell_0
		(
			.CLK(CLK),
			.RESET(RESET),
			.EN(1'b1),
			.out_ipp({(M-1){1'b0}}),
			.dividend(dividend[N-1]),
			.divisor(divisor),
			.merchant(merchant[N-1]),
			.out(out_in[N-1]),
			.CK(CK[N-1])
		);
	genvar i;
	generate
		for(i=N-2;i>=0;i=i-1) begin:step_x
			divider_cell #(.N(N), .M(M)) cell_x
				(
					.CLK(CLK),
					.RESET(RESET),
					.EN(CK[i+1]),
					.out_ipp(out_in[i+1]),
					.dividend(dividend[i]),
					.divisor(divisor),
					.merchant(merchant[i]),
					.out(out_in[i]),
					.CK(CK[i])
				);
		end
	endgenerate
	assign remainder=out_in[0];
	assign ACK=CK[0];

endmodule