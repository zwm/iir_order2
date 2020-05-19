
module tb();
// macro
`include "tb_define.v"
// port
reg clk, rstn, block_en, din_vld;
wire [`DWIDTH-1:0] din, dout; reg [`DWIDTH-1:0] din_raw;
reg [`CASCADE_LEVEL*`CWIDTH*5 - 1:0] coefs;
// test bench
integer chk_cnt, err_cnt, sim_end; reg [64*8-1:0] log_path;
reg [`CWIDTH - 1:0] din_scale;

// main
initial begin
    sys_init;
    #50_000;
    test_case;
    #1000_000;
    $finish;
end
// din proc
wire [`DWIDTH + `CWIDTH - 1:0] din_mult;
wire [`DWIDTH + `CWIDTH - 4:0] din_mult_sat;
wire [`DWIDTH           - 1:0] din_mult_round;
assign din_mult = $signed(din_raw) * $signed(din_scale);
sat_handle #(`DWIDTH + `CWIDTH, `DWIDTH + `CWIDTH - 3)
u_sat  (
    .din        ( din_mult      ),
    .dout       ( din_mult_sat  )
);
round_handle #(`DWIDTH + `CWIDTH - 3, `DWIDTH)
u_round  (
    .din        ( din_mult_sat  ),
    .dout       ( din           )
);
// inst iir
iir_cascade #(
    .CASCADE_LEVEL      ( `CASCADE_LEVEL    ),
    .DWIDTH             ( `DWIDTH           ),
    .CWIDTH             ( `CWIDTH           ))
u_iir_cascade (
    .clk                ( clk               ),
    .rstn               ( rstn              ),
    .block_en           ( block_en          ),
    .coefs              ( coefs             ),
    .din_vld            ( din_vld           ),
    .din                ( din               ),
    .dout               ( dout              )
);
// fsdb
`ifdef DUMP_FSDB
initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0, tb);
    $fsdbDumpMDA();
end
`endif
// clkgen
initial begin
    @(posedge rstn);
    forever #(`CLK_PERIOD/2) clk = ~clk;
end
// init
task sys_init;
    begin
        // ports
        clk = 0;
        rstn = 0;
        block_en = 0;
        din_vld = 0;
        din_raw = 0;
        coefs = 0;
        // tb
        chk_cnt = 0;
        err_cnt = 0;
        sim_end = 0;
        din_scale = 0;
        // por
        por;
    end
endtask
// por
task por;
    begin
        rstn = 0;
        #100;
        rstn = 1;
        #100;
        block_en = 1;
    end
endtask
// read log path
task read_log_path;
    integer fp, ret;
    begin
        fp = $fopen(`FILE_LOG_PATH, "r");
        ret = $fscanf(fp, "%s", log_path);
        $fclose(fp);
    end
endtask
// driver
task drv_cfg;
    integer fp, ret, i, tmp;
    begin
        fp = $fopen({log_path, "/ram.txt"}, "r");
        ret = $fscanf(fp, "%d", din_scale);
        for (i = 0; i < `CASCADE_LEVEL*5; i = i + 1) begin
            ret = $fscanf(fp, "%d", tmp[`CWIDTH-1:0]);
            coefs = {tmp[`CWIDTH-1:0], coefs[`CASCADE_LEVEL*`CWIDTH*5 - 1:`CWIDTH]};
        end
    end
endtask
// driver
task drv_din;
    integer fp, ret, i, tmp;
    begin
        fp = $fopen({log_path, "/input.txt"}, "r");
        begin: MAIN_LOOP_DIN
            for (i = 0; i < `SIM_POINTS; i = i + 1) begin
                repeat(30) @(posedge clk);
                @(posedge clk); #1;
                ret = $fscanf(fp, "%d", din_raw[15:0]);
                din_raw[`DWIDTH-1:16] = {(`DWIDTH-16){din_raw[15]}};
                if (ret === 0) disable MAIN_LOOP_DIN;
                din_vld = 1;
                @(posedge clk); #1;
                din_vld = 0;
            end
        end
        sim_end = 1;
    end
endtask
// checker
task chk;
    begin
    end
endtask
// test case
task test_case;
    begin
        read_log_path;
        #100;
        fork
            begin: DRV
                drv_cfg;
                drv_din;
            end
            begin: CHK
                chk;
            end
        join
    end
endtask

endmodule

