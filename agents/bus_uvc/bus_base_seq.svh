//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_base_seq extends uvm_sequence #(bus_seq_item);
  `uvm_object_utils(bus_base_seq)

  extern function new(string name = "");

  rand bit [31:0]  addr;
  rand bit [31:0]  wdata;
  rand bit [31:0]  rdata;

  rand bus_seq_item::operation_e operation;
  bus_seq_item req;

  extern virtual task body();

endclass : bus_base_seq


function bus_base_seq::new(string name = "");
  super.new(name);

  req = bus_seq_item::type_id::create("req");
endfunction : new


task bus_base_seq::body();
  req.operation = operation;
  req.addr      = addr;
  req.wdata     = wdata;
  start_item(req);
  rdata = req.rdata;
  finish_item(req);
endtask : body
