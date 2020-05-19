module round_handle #(
parameter WI = 31,
parameter WO = 10
)(
input [WI-1:0] din,
output [WO-1:0] dout
);

wire [WI-1:0] din_abs;
wire [WO-1:0] din_abs_rnd;

assign din_abs = din[WI-1] ? ~din+1 : din;
assign din_abs_rnd = &din_abs[WI-2:WI-WO] ? din_abs[WI-1:WI-WO]
                                          : din_abs[WI-1:WI-WO] + din_abs[WI-WO-1];
assign dout = din[WI-1] ? ~din_abs_rnd+1 : din_abs_rnd;

endmodule
