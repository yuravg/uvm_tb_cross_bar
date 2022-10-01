//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef BUS_AGENT_PKG_SV
	`define BUS_AGENT_PKG_SV

package bus_agent_pkg;

	`include "uvm_macros.svh"
  import uvm_pkg::*;

	`include "bus_seq_item.svh"

  typedef uvm_sequencer #(bus_seq_item) bus_sequencer;
  typedef virtual bus_if bus_vif;

  typedef enum bit {ACK=0, SEND=1} driver_mode_e;

	`include "bus_driver.svh"
	`include "bus_monitor.svh"
	`include "bus_config.svh"
	`include "bus_agent.svh"

	`include "bus_scoreboard.svh"

  `include "bus_base_seq.svh"
  `include "bus_transaction.svh"
  `include "bus_idle.svh"
  `include "bus_read.svh"
  `include "bus_write.svh"
  `include "bus_ack.svh"

endpackage : bus_agent_pkg

`endif // BUS_AGENT_PKG_SV
