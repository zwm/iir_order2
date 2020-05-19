
module iir_cascade #(parameter CASCADE_LEVEL = 10,
                    parameter DWIDTH = 24,
                    parameter CWIDTH = 24   )(
    input clk,
    input rstn,
    input block_en,
    input [CASCADE_LEVEL*CWIDTH*5 - 1:0] coefs, // each level has 5 coefs with bitwidth CWIDTH
    input din_vld,
    input [DWIDTH - 1:0] din,
    output reg [DWIDTH - 1:0] dout
);
// regs
reg [DWIDTH - 1:0] x0_reg [CASCADE_LEVEL-1:0];
reg [DWIDTH - 1:0] x1_reg [CASCADE_LEVEL-1:0];
reg [DWIDTH - 1:0] x2_reg [CASCADE_LEVEL-1:0];
reg [DWIDTH - 1:0] y1_reg [CASCADE_LEVEL-1:0];
reg [DWIDTH - 1:0] y2_reg [CASCADE_LEVEL-1:0];
reg [CWIDTH - 1:0] coef_b0, coef_b1, coef_b2, coef_a1, coef_a2;
reg [DWIDTH - 1:0] x0, x1, x2, y1, y2; wire [DWIDTH - 1:0] y0;
// cnt
reg cnt_en; reg [4:0] cnt; reg din_vld_d1;
always @(posedge clk or negedge rstn)
    if (~rstn) begin
        cnt <= 0;
        cnt_en <= 0;
        din_vld_d1 <= 0;
    end
    else if (~block_en) begin
        cnt <= 0;
        cnt_en <= 0;
        din_vld_d1 <= 0;
    end
    else begin
        din_vld_d1 <= din_vld;
        if (din_vld_d1) begin
            cnt <= 0;
            cnt_en <= 1;
        end
        else if (cnt_en) begin
            if (cnt == CASCADE_LEVEL - 1) begin
                cnt <= 0;
                cnt_en <= 0;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end
// inst iir_order2
iir_order2  #(
    .DWIDTH             ( DWIDTH                ),
    .CWIDTH             ( CWIDTH                ))
u_iir_order2 (
    .coef_b0            ( coef_b0               ),
    .coef_b1            ( coef_b1               ),
    .coef_b2            ( coef_b2               ),
    .coef_a1            ( coef_a1               ),
    .coef_a2            ( coef_a2               ),
    .x0                 ( x0                    ),
    .x1                 ( x1                    ),
    .x2                 ( x2                    ),
    .y1                 ( y1                    ),
    .y2                 ( y2                    ),
    .y0                 ( y0                    )
);
// coef mux
always @(*)
    case (cnt)
        0: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[1*CWIDTH*5-1:0*CWIDTH*5];
            x0 = x0_reg[0];
            x1 = x1_reg[0];
            x2 = x2_reg[0];
            y1 = y1_reg[0];
            y2 = y2_reg[0];
        end
        1: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[2*CWIDTH*5-1:1*CWIDTH*5];
            x0 = x0_reg[1];
            x1 = x1_reg[1];
            x2 = x2_reg[1];
            y1 = y1_reg[1];
            y2 = y2_reg[1];
        end
        2: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[3*CWIDTH*5-1:2*CWIDTH*5];
            x0 = x0_reg[2];
            x1 = x1_reg[2];
            x2 = x2_reg[2];
            y1 = y1_reg[2];
            y2 = y2_reg[2];
        end
        3: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[4*CWIDTH*5-1:3*CWIDTH*5];
            x0 = x0_reg[3];
            x1 = x1_reg[3];
            x2 = x2_reg[3];
            y1 = y1_reg[3];
            y2 = y2_reg[3];
        end
        4: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[5*CWIDTH*5-1:4*CWIDTH*5];
            x0 = x0_reg[4];
            x1 = x1_reg[4];
            x2 = x2_reg[4];
            y1 = y1_reg[4];
            y2 = y2_reg[4];
        end
        5: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[6*CWIDTH*5-1:5*CWIDTH*5];
            x0 = x0_reg[5];
            x1 = x1_reg[5];
            x2 = x2_reg[5];
            y1 = y1_reg[5];
            y2 = y2_reg[5];
        end
        6: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[7*CWIDTH*5-1:6*CWIDTH*5];
            x0 = x0_reg[6];
            x1 = x1_reg[6];
            x2 = x2_reg[6];
            y1 = y1_reg[6];
            y2 = y2_reg[6];
        end
        7: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[8*CWIDTH*5-1:7*CWIDTH*5];
            x0 = x0_reg[7];
            x1 = x1_reg[7];
            x2 = x2_reg[7];
            y1 = y1_reg[7];
            y2 = y2_reg[7];
        end
        8: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[9*CWIDTH*5-1:8*CWIDTH*5];
            x0 = x0_reg[8];
            x1 = x1_reg[8];
            x2 = x2_reg[8];
            y1 = y1_reg[8];
            y2 = y2_reg[8];
        end
        9: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[10*CWIDTH*5-1:9*CWIDTH*5];
            x0 = x0_reg[9];
            x1 = x1_reg[9];
            x2 = x2_reg[9];
            y1 = y1_reg[9];
            y2 = y2_reg[9];
        end
        default: begin
            {coef_a2, coef_a1, coef_b2, coef_b1, coef_b0} = coefs[1*CWIDTH*5-1:0*CWIDTH*5];
            x0 = x0_reg[0];
            x1 = x1_reg[0];
            x2 = x2_reg[0];
            y1 = y1_reg[0];
            y2 = y2_reg[0];
        end
    endcase

// x0_reg
always @(posedge clk or negedge rstn)
    if (~rstn)
        x0_reg[0] <= 0;
    else if (~block_en)
        x0_reg[0] <= 0;
    else if (din_vld)
        x0_reg[0] <= din;
integer i;
// delay chain
always @(posedge clk or negedge rstn)
    if (~rstn) begin
        for (i=0; i<CASCADE_LEVEL-1; i=i+1) x0_reg[i+1] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) x1_reg[i] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) x2_reg[i] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) y1_reg[i] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) y2_reg[i] <= {DWIDTH{1'b0}};
    end
    else if (~block_en) begin
        for (i=0; i<CASCADE_LEVEL-1; i=i+1) x0_reg[i+1] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) x1_reg[i] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) x2_reg[i] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) y1_reg[i] <= {DWIDTH{1'b0}};
        for (i=0; i<CASCADE_LEVEL; i=i+1) y2_reg[i] <= {DWIDTH{1'b0}};
    end
    else if (cnt_en) begin
        if (cnt == 0) begin
            x1_reg[0] <= x0_reg[0];
            x2_reg[0] <= x1_reg[0];
            y1_reg[0] <= y0;
            y2_reg[0] <= y1_reg[0];
            x0_reg[1] <= y0;
        end
        if (cnt == 1) begin
            x1_reg[1] <= x0_reg[1];
            x2_reg[1] <= x1_reg[1];
            y1_reg[1] <= y0;
            y2_reg[1] <= y1_reg[1];
            x0_reg[2] <= y0;
        end
        if (cnt == 2) begin
            x1_reg[2] <= x0_reg[2];
            x2_reg[2] <= x1_reg[2];
            y1_reg[2] <= y0;
            y2_reg[2] <= y1_reg[2];
            x0_reg[3] <= y0;
        end
        if (cnt == 3) begin
            x1_reg[3] <= x0_reg[3];
            x2_reg[3] <= x1_reg[3];
            y1_reg[3] <= y0;
            y2_reg[3] <= y1_reg[3];
            x0_reg[4] <= y0;
        end
        if (cnt == 4) begin
            x1_reg[4] <= x0_reg[4];
            x2_reg[4] <= x1_reg[4];
            y1_reg[4] <= y0;
            y2_reg[4] <= y1_reg[4];
            x0_reg[5] <= y0;
        end
        if (cnt == 5) begin
            x1_reg[5] <= x0_reg[5];
            x2_reg[5] <= x1_reg[5];
            y1_reg[5] <= y0;
            y2_reg[5] <= y1_reg[5];
            x0_reg[6] <= y0;
        end
        if (cnt == 6) begin
            x1_reg[6] <= x0_reg[6];
            x2_reg[6] <= x1_reg[6];
            y1_reg[6] <= y0;
            y2_reg[6] <= y1_reg[6];
            x0_reg[7] <= y0;
        end
        if (cnt == 7) begin
            x1_reg[7] <= x0_reg[7];
            x2_reg[7] <= x1_reg[7];
            y1_reg[7] <= y0;
            y2_reg[7] <= y1_reg[7];
            x0_reg[8] <= y0;
        end
        if (cnt == 8) begin
            x1_reg[8] <= x0_reg[8];
            x2_reg[8] <= x1_reg[8];
            y1_reg[8] <= y0;
            y2_reg[8] <= y1_reg[8];
            x0_reg[9] <= y0;
        end
        if (cnt == 9) begin
            x1_reg[9] <= x0_reg[9];
            x2_reg[9] <= x1_reg[9];
            y1_reg[9] <= y0;
            y2_reg[9] <= y1_reg[9];
        end
    end
// output
always @(posedge clk or negedge rstn)
    if (~rstn)
        dout <= 0;
    else if (~block_en)
        dout <= 0;
    else if (cnt_en == 1 && cnt == 9)
        dout <= y0;

endmodule

