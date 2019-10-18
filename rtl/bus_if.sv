//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

import bus_if_pkg::*;

interface bus_if #(BUS_AW = AW, BUS_DW = DW);

// synthesis translate_off
logic clk;
logic reset;
// synthesis translate_on

logic              req;
logic [BUS_AW-1:0] addr;
logic              cmd;   // 0/1 - read/write
logic [BUS_DW-1:0] wdata;
logic              ack;
logic [BUS_DW-1:0] rdata;
logic              resp;

modport master(
	input  req,
	input  addr,
	input  cmd,
	input  wdata,
	output ack,
	output rdata,
	output resp
);

modport slave(
	output req,
	output addr,
	output cmd,
	output wdata,
	input  ack,
	input  rdata,
	input  resp
);

endinterface
