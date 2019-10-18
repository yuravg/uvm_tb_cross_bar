//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_ack extends bus_base_seq;
  `uvm_object_utils(bus_ack)

  extern function new(string name = "");
  extern task body();

endclass : bus_ack


function bus_ack::new(string name = "");
  super.new(name);
endfunction : new


task bus_ack::body();
  operation = bus_seq_item::ACK;
  super.body();
endtask : body
