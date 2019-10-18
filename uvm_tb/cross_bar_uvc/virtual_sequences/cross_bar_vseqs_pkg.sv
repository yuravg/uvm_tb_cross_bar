//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef CROSS_BAR_VSEQS_PKG_SV
  `define CROSS_BAR_VSEQS_PKG_SV

package cross_bar_vseqs_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import bus_agent_pkg::*;
  import bus_seqs_pkg::*;
  import cross_bar_agent_pkg::*;

  typedef uvm_sequence #(uvm_sequence_item) uvm_virtual_sequence;

  typedef cross_bar_seq_item item_t;

  `include "cross_bar_base_vseq.svh"
  `include "cross_bar_transaction.svh"
  `include "cross_bar_write.svh"
  `include "cross_bar_read.svh"
  `include "cross_bar_multi_tr.svh"

endpackage : cross_bar_vseqs_pkg

`endif // CROSS_BAR_VSEQS_PKG_SV
