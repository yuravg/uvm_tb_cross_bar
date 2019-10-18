//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef BUS_SEQS_PKG_SV
  `define BUS_SEQS_PKG_SV

package bus_seqs_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import bus_agent_pkg::*;

  `include "bus_base_seq.svh"
  `include "bus_transaction.svh"
  `include "bus_idle.svh"
  `include "bus_read.svh"
  `include "bus_write.svh"
  `include "bus_ack.svh"

endpackage : bus_seqs_pkg

`endif // BUS_SEQS_PKG_SV
