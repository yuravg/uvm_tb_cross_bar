//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_transaction extends bus_base_seq;
  `uvm_object_utils(bus_transaction)

  extern function new(string name = "");

  bus_seq_item item;

  extern task body();

endclass : bus_transaction


function bus_transaction::new(string name = "");
  super.new(name);

  item = bus_seq_item::type_id::create("item");
endfunction : new


task bus_transaction::body();
  operation = this.item.operation;
  addr = this.item.addr;
  wdata = this.item.wdata;
  super.body();
  this.item.rdata = rdata;
endtask : body
