//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef _BUS_IF_PKG
	`define _BUS_IF_PKG

package bus_if_pkg;

// Values for Simulation
// synthesis translate_off
localparam AW = 32;
localparam DW = 32;
`define DEFINE_BUS_IF_PKG
// synthesis translate_on

// Values for Synthesis
`ifndef DEFINE_BUS_IF_PKG
localparam AW = 8;
localparam DW = 16;
`endif // DEFINE_BUS_IF_PKG

endpackage

`endif // _BUS_IF_PKG
