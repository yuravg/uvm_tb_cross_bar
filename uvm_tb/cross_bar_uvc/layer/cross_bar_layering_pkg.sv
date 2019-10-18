//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef CROSS_BAR_LAYERING_PKG_SV
  `define CROSS_BAR_LAYERING_PKG_SV

package cross_bar_layering_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import bus_agent_pkg::*;
  import cross_bar_agent_pkg::*;

  `include "cross_bar2bus_seq.svh"
  `include "bus2cross_bar_monitor.svh"
  `include "cross_bar_layering.svh"

endpackage : cross_bar_layering_pkg

`endif // CROSS_BAR_LAYERING_PKG_SV
