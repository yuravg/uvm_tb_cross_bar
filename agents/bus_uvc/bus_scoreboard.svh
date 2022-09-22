//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

typedef class bus_scoreboard;

class bus_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(bus_scoreboard)

  uvm_analysis_port #(bus_seq_item) ap;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual function void info(bus_seq_item req);

endclass : bus_scoreboard


function bus_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void bus_scoreboard::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction : build_phase


task bus_scoreboard::run_phase(uvm_phase phase);
  bus_seq_item req;
  req = bus_seq_item::type_id::create("req");
  forever begin
    ap.get(req);
    `uvm_info("bus", req.convert2string(), UVM_LOW)
  end
endtask : run_phase


function void bus_scoreboard::info(bus_seq_item req);
  `uvm_info("bus", req.convert2string(), UVM_LOW)
endfunction : info
