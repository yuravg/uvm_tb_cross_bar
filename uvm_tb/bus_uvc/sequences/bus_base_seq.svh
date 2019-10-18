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

  rand bus_seq_item::operation_t operation;
  bus_seq_item item;

  extern virtual task body();

endclass : bus_base_seq


function bus_base_seq::new(string name = "");
  super.new(name);

  item = bus_seq_item::type_id::create("item");
endfunction : new


task bus_base_seq::body();
  item.operation = operation;
  item.addr      = addr;
  item.wdata     = wdata;
  start_item(item);
  rdata = item.rdata;
  finish_item(item);
endtask : body
