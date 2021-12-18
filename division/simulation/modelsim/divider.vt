/*
Author: DUMU
Created at: 2021.12.17 22:44 BeiJing

test bench

*/
`timescale 1ns/1ns

module divider_vlg_tst ;
    parameter N=8;
    parameter M=8;
    reg CLK;
    reg RESET;
    reg EN;
    reg [N-1:0] dividend;
    reg [M-1:0] divisor;
    wire ACK;
    wire [N-1:0] merchant;
    wire [M-1:0] remainder;
    divider #(.N(N), .M(M)) test
        (
            .CLK(CLK),
            .RESET(RESET),
            .EN(EN),
            .dividend(dividend),
            .divisor(divisor),
            .ACK(ACK),
            .merchant(merchant),
            .remainder(remainder)
        );
    initial begin
        CLK<=1'b0;
        RESET<=1'b1;
        divisor<='b0;
        dividend<='b0;
        EN<=1'b0;
        #8;
        RESET<=1'b0;
        dividend<=8'b10101101;
        divisor<=8'b00010110;
    end
    always@(*) begin
        #1 CLK<=~CLK;
    end
    always @(posedge(CLK)) begin
        if(ACK) begin
            RESET<=1'b1;
            $stop;
        end
    end

endmodule // test