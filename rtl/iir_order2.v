
module iir_order2 #(parameter DWIDTH = 16,
                    parameter CWIDTH = 24   )(
    input [CWIDTH - 1:0] coef_b0, coef_b1, coef_b2, coef_a1, coef_a2,
    input [DWIDTH - 1:0] x0, x1, x2, y1, y2,
    output [DWIDTH - 1:0] y0
);
// mult
wire [DWIDTH + CWIDTH - 1:0] mult0_out = $signed(x0) * $signed(coef_b0);
wire [DWIDTH + CWIDTH - 1:0] mult1_out = $signed(x1) * $signed(coef_b1);
wire [DWIDTH + CWIDTH - 1:0] mult2_out = $signed(x2) * $signed(coef_b2);
wire [DWIDTH + CWIDTH - 1:0] mult3_out = $signed(y1) * $signed(coef_a1);
wire [DWIDTH + CWIDTH - 1:0] mult4_out = $signed(y2) * $signed(coef_a2);
// sum
wire [CWIDTH + DWIDTH + 3 - 1:0] sum = $signed(mult0_out) + $signed(mult1_out) + $signed(mult2_out) + $signed(mult3_out) + $signed(mult4_out);
// truncate
wire [DWIDTH + CWIDTH - 4:0] sum_sat;
wire [DWIDTH          - 1:0] sum_round;
sat_handle #(DWIDTH + CWIDTH + 3, DWIDTH + CWIDTH - 3)
u_sat (
    .din        ( sum           ),
    .dout       ( sum_sat       )
);
round_handle #(DWIDTH + CWIDTH - 3, DWIDTH)
u_round (
    .din        ( sum_sat       ),
    .dout       ( sum_round     )
);
// output
assign y0 = sum_round;

endmodule

