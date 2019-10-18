//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef TEST_PKG_SV
  `define TEST_PKG_SV

package test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import bus_agent_pkg::*;
  import cross_bar_vseqs_pkg::*;
  import cross_bar_agent_pkg::*;
  import env_pkg::*;

  `include "base_test.svh"

  `include "test_transaction.svh"
  `include "test_write.svh"
  `include "test_read.svh"
  `include "test_multi_tr.svh"
  `include "test_arbitrage.svh"

endpackage : test_pkg

`endif // TEST_PKG_SV
