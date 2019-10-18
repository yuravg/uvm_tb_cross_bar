//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_layering extends uvm_subscriber #(bus_seq_item);
  `uvm_component_utils(cross_bar_layering)

  uvm_analysis_port #(cross_bar_seq_item) ap;

  cross_bar_sequencer cb_seqr;
  cross_bar2bus_seq   cb2bus_seq;

  bus2cross_bar_monitor mon;
  bus_agent             agt;

  int master;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern function void write(bus_seq_item t);
  extern function void connect2agent(bus_agent agt);
  extern function void set_master_bus_num(input int num);

endclass : cross_bar_layering


function cross_bar_layering::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void cross_bar_layering::build_phase(uvm_phase phase);
  super.build_phase(phase);

  ap = new("ap", this);

  cb_seqr    = cross_bar_sequencer::type_id::create("cb_seqr", this);
  mon        = bus2cross_bar_monitor::type_id::create("mon", this);
  cb2bus_seq = cross_bar2bus_seq::type_id::create("cb2bus_seq", this);
endfunction : build_phase


function void cross_bar_layering::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	mon.ap.connect(ap);
endfunction : connect_phase


task cross_bar_layering::run_phase(uvm_phase phase);
  cb2bus_seq.seqr = cb_seqr;

  fork
    cb2bus_seq.start(agt.seqr);
  join_none
endtask : run_phase


function void cross_bar_layering::write(bus_seq_item t);
  mon.write(t);
endfunction : write


function void cross_bar_layering::connect2agent(bus_agent agt);
  bus_agent that;
  if (!$cast(that, agt)) begin
    `uvm_error("cross_bar", "Error! Agent type mismatch. Agt is not a bus_agent type!")
  end
  this.agt = agt;
  this.agt.ap.connect(analysis_export);
endfunction : connect2agent


function void cross_bar_layering::set_master_bus_num(input int num);
  this.master = num;
  this.mon.master = this.master;
endfunction : set_master_bus_num
