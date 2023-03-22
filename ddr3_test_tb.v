`timescale 1ns/1ps
module ddr3_test_tb(
);

\\wire and reg
	reg		ref_clk;
	reg		resetn;
	reg	[CTRL_ADDR_WIDTH-1:0]	axi_awaddr;
	reg		axi_awuser_ap;
	reg	[3:0]	axi_awuser_id;
	reg	[3:0]	axi_awlen;
	reg		axi_awvalid;
	reg	[MEM_DQ_WIDTH*8-1:0]	axi_wdata;
	reg	[MEM_DQ_WIDTH-1:0]	axi_wstrb;
	reg	[CTRL_ADDR_WIDTH-1:0]	axi_araddr;
	reg		axi_aruser_ap;
	reg	[3:0]	axi_aruser_id;
	reg	[3:0]	axi_arlen;
	reg		axi_arvalid;
	reg		apb_clk;
	reg		apb_rst_n;
	reg		apb_sel;
	reg		apb_enable;
	reg	[7:0]	apb_addr;
	reg		apb_write;
	reg	[15:0]	apb_wdata;
	reg		force_ck_dly_en;
	reg	[7:0]	force_ck_dly_set_bin;
	reg	[1:0]	init_read_clk_ctrl;
	reg	[3:0]	init_slip_step;
	reg		force_read_clk_ctrl;
	reg		ddrphy_gate_update_en;
	reg		rd_fake_stop;
	wire		ddr_init_done;
	wire		ddrphy_clkin;
	wire		pll_lock;
	wire		axi_awready;
	wire		axi_wready;
	wire	[3:0]	axi_wusero_id;
	wire		axi_wusero_last;
	wire		axi_arready;
	wire	[8*MEM_DQ_WIDTH-1:0]	axi_rdata;
	wire	[3:0]	axi_rid;
	wire		axi_rlast;
	wire		axi_rvalid;
	wire		apb_ready;
	wire	[15:0]	apb_rdata;
	wire		apb_int;
	wire	[34*MEM_DQS_WIDTH-1:0]	debug_data;
	wire	[13*MEM_DQS_WIDTH-1:0]	debug_slice_state;
	wire	[21:0]	debug_calib_ctrl;
	wire	[7:0]	ck_dly_set_bin;
	wire	[7:0]	dll_step;
	wire		dll_lock;
	wire	[MEM_DQS_WIDTH-1:0]	update_com_val_err_flag;
	wire		mem_rst_n;
	wire		mem_ck;
	wire		mem_ck_n;
	wire		mem_cke;
	wire		mem_cs_n;
	wire		mem_ras_n;
	wire		mem_cas_n;
	wire		mem_we_n;
	wire		mem_odt;
	wire	[MEM_ROW_WIDTH-1:0]	mem_a;
	wire	[MEM_BANK_WIDTH-1:0]	mem_ba;
	wire	[MEM_DM_WIDTH-1:0]	mem_dm;
	reg	[MEM_DQS_WIDTH-1:0]	mem_dqs;
	reg	[MEM_DQS_WIDTH-1:0]	mem_dqs_n;
	reg	[MEM_DQ_WIDTH-1:0]	mem_dq;


\\initial assignment
initial begin
	ref_clk <= 1'b0;
	resetn <= 1'b0;
	axi_awaddr <= 28'b0;
	axi_awuser_ap <= 1'b0;
	axi_awuser_id <= 4'b0;
	axi_awlen <= 4'b0;
	axi_awvalid <= 1'b0;
	axi_wdata <= 256'b0;
	axi_wstrb <= 32'b0;
	axi_araddr <= 28'b0;
	axi_aruser_ap <= 1'b0;
	axi_aruser_id <= 4'b0;
	axi_arlen <= 4'b0;
	axi_arvalid <= 1'b0;
	apb_clk <= 1'b0;
	apb_rst_n <= 1'b0;
	apb_sel <= 1'b0;
	apb_enable <= 1'b0;
	apb_addr <= 8'b0;
	apb_write <= 1'b0;
	apb_wdata <= 16'b0;
	force_ck_dly_en <= 1'b0;
	force_ck_dly_set_bin <= 8'b0;
	init_read_clk_ctrl <= 2'b0;
	init_slip_step <= 4'b0;
	force_read_clk_ctrl <= 1'b0;
	ddrphy_gate_update_en <= 1'b0;
	rd_fake_stop <= 1'b0;
end



ddr3_test	ddr3_test_1 #(
	parameter	DFI_CLK_PERIOD = 10000,
	parameter	MEM_ROW_WIDTH = 15,
	parameter	MEM_COLUMN_WIDTH = 10,
	parameter	MEM_BANK_WIDTH = 3,
	parameter	MEM_DQ_WIDTH = 32,
	parameter	MEM_DM_WIDTH = 4,
	parameter	MEM_DQS_WIDTH = 4,
	parameter	REGION_NUM = 3,
	parameter	CTRL_ADDR_WIDTH = 28
)(
	.ref_clk(ref_clk),
	.resetn(resetn),
	.axi_awaddr(axi_awaddr),
	.axi_awuser_ap(axi_awuser_ap),
	.axi_awuser_id(axi_awuser_id),
	.axi_awlen(axi_awlen),
	.axi_awvalid(axi_awvalid),
	.axi_wdata(axi_wdata),
	.axi_wstrb(axi_wstrb),
	.axi_araddr(axi_araddr),
	.axi_aruser_ap(axi_aruser_ap),
	.axi_aruser_id(axi_aruser_id),
	.axi_arlen(axi_arlen),
	.axi_arvalid(axi_arvalid),
	.apb_clk(apb_clk),
	.apb_rst_n(apb_rst_n),
	.apb_sel(apb_sel),
	.apb_enable(apb_enable),
	.apb_addr(apb_addr),
	.apb_write(apb_write),
	.apb_wdata(apb_wdata),
	.force_ck_dly_en(force_ck_dly_en),
	.force_ck_dly_set_bin(force_ck_dly_set_bin),
	.init_read_clk_ctrl(init_read_clk_ctrl),
	.init_slip_step(init_slip_step),
	.force_read_clk_ctrl(force_read_clk_ctrl),
	.ddrphy_gate_update_en(ddrphy_gate_update_en),
	.rd_fake_stop(rd_fake_stop),
	.ddr_init_done(ddr_init_done),
	.ddrphy_clkin(ddrphy_clkin),
	.pll_lock(pll_lock),
	.axi_awready(axi_awready),
	.axi_wready(axi_wready),
	.axi_wusero_id(axi_wusero_id),
	.axi_wusero_last(axi_wusero_last),
	.axi_arready(axi_arready),
	.axi_rdata(axi_rdata),
	.axi_rid(axi_rid),
	.axi_rlast(axi_rlast),
	.axi_rvalid(axi_rvalid),
	.apb_ready(apb_ready),
	.apb_rdata(apb_rdata),
	.apb_int(apb_int),
	.debug_data(debug_data),
	.debug_slice_state(debug_slice_state),
	.debug_calib_ctrl(debug_calib_ctrl),
	.ck_dly_set_bin(ck_dly_set_bin),
	.dll_step(dll_step),
	.dll_lock(dll_lock),
	.update_com_val_err_flag(update_com_val_err_flag),
	.mem_rst_n(mem_rst_n),
	.mem_ck(mem_ck),
	.mem_ck_n(mem_ck_n),
	.mem_cke(mem_cke),
	.mem_cs_n(mem_cs_n),
	.mem_ras_n(mem_ras_n),
	.mem_cas_n(mem_cas_n),
	.mem_we_n(mem_we_n),
	.mem_odt(mem_odt),
	.mem_a(mem_a),
	.mem_ba(mem_ba),
	.mem_dm(mem_dm),
	.mem_dqs(mem_dqs),
	.mem_dqs_n(mem_dqs_n),
	.mem_dq(mem_dq)
);
