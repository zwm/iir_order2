module sat_handle #(
parameter WI = 31,
parameter WO = 10,
parameter NEG_SAT_FLAG = 1
)(
input [WI-1:0] din,
output [WO-1:0] dout
);

wire not_sat_flg;
wire [WI-WO:0] sat_part;

assign sat_part[WI-WO:0] = din[WI-1:WO-1];
assign not_sat_flg = (~(|sat_part)) | (&sat_part);
assign dout = not_sat_flg ? (NEG_SAT_FLAG & (din[WO-1] & (~(|din[WO-2:0])))) ? {1'b1, {(WO-2){1'b0}}, 1'b1}
                                                                             : din[WO-1:0]
                          : (NEG_SAT_FLAG & din[WI-1]) ? {1'b1, {(WO-2){1'b0}}, 1'b1}
                                                       : {din[WI-1],{(WO-1){~din[WI-1]}}};

endmodule
