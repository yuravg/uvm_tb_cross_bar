//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_agent extends uvm_agent;
  `uvm_component_utils(bus_agent)

  bus_config    cfg;
  bus_sequencer seqr;
  bus_driver    drv;
  bus_monitor   mon;

  uvm_analysis_port #(bus_seq_item) ap;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : bus_agent


function bus_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void bus_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(bus_config)::get(this, "", "config", cfg)) begin
    `uvm_fatal("build_phase", "Unable to get config (type: bus_config) from uvm_config_db")
  end

  ap   = new("ap", this);
  seqr = new("seqr", this);
  drv  = bus_driver::type_id::create("drv", this);
  mon  = bus_monitor::type_id::create("mon", this);
endfunction : build_phase


function void bus_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  drv.driver_mode = cfg.driver_mode;
  drv.vif = cfg.vif;
  drv.seq_item_port.connect(seqr.seq_item_export);

  mon.driver_mode = cfg.driver_mode;
  mon.vif = cfg.vif;
  ap      = mon.ap;
endfunction : connect_phase
