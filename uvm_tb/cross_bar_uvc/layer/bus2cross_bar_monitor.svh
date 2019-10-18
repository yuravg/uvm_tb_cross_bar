//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus2cross_bar_monitor extends uvm_subscriber #(bus_seq_item);
  `uvm_component_utils(bus2cross_bar_monitor)

  uvm_analysis_port #(cross_bar_seq_item) ap;

  uvm_phase run_phase = uvm_run_phase::get();

  extern function new(string name, uvm_component parent);

  cross_bar_seq_item cb_item;

  int master;

  extern function void write(bus_seq_item t);

endclass : bus2cross_bar_monitor


function bus2cross_bar_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  ap = new("ap", this);
endfunction : new


function void bus2cross_bar_monitor::write(bus_seq_item t);
  cb_item = cross_bar_seq_item::type_id::create("cb_item",, get_full_name());

  cb_item.master    = master;
  cb_item.addr      = t.addr;
  cb_item.wdata     = t.wdata;
  cb_item.rdata     = t.rdata;
  cb_item.operation = t.operation;

  ap.write(cb_item);
endfunction : write
