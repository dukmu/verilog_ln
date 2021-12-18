/*
Author: DUMU
Created at: 2021.12.17 22:44 BeiJing

unit of divider.v:divider
*/
module divider_cell #(parameter N=5, parameter M=3)
    (
        input CLK,
        input RESET,
        input EN,
        input[M-1:0] out_ipp,
        input dividend,
        input[M-1:0] divisor,
        output reg merchant,
        output reg[M-1:0] out,
        output reg CK
    );
    always@(posedge(CLK) or posedge(RESET)) begin
        if(RESET) begin
            CK<=1'b0;
            merchant<=1'b0;
            out<=1'b0;
        end
        else if(EN) begin
            CK<=1'b1;
            if({out_ipp, dividend}>=divisor) begin
                merchant<=1'b1;
                out<={out_ipp, dividend}-divisor;
            end
            else begin
                merchant<=1'b0;
                out<={out_ipp, dividend};
            end
        end
        else begin
            CK<=1'b0;
            merchant<=1'b0;
            out<=1'b0;
        end
    end
endmodule