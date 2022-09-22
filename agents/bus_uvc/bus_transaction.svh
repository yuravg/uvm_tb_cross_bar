//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_transaction extends bus_base_seq;
  `uvm_object_utils(bus_transaction)

  extern function new(string name = "");

  bus_seq_item req;

  extern task body();

endclass : bus_transaction


function bus_transaction::new(string name = "");
  super.new(name);

  req = bus_seq_item::type_id::create("req");
endfunction : new


task bus_transaction::body();
  operation = this.req.operation;
  addr = this.req.addr;
  wdata = this.req.wdata;
  super.body();
  this.req.rdata = rdata;
endtask : body
