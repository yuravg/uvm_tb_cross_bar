//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef CROSS_BAR_AGENT_PKG_SV
  `define CROSS_BAR_AGENT_PKG_SV

package cross_bar_agent_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import bus_agent_pkg::*;

  `include "cross_bar_seq_item.svh"

  typedef uvm_sequencer #(cross_bar_seq_item) cross_bar_sequencer;

endpackage : cross_bar_agent_pkg

`endif // CROSS_BAR_AGENT_PKG_SV
