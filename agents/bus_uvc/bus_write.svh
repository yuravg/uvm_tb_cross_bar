//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_write extends bus_base_seq;
  `uvm_object_utils(bus_write)

  extern function new(string name = "");
  extern task body();

endclass : bus_write


function bus_write::new(string name = "");
  super.new(name);
endfunction : new


task bus_write::body();
  operation = bus_seq_item::WRITE;
  super.body();
endtask : body
