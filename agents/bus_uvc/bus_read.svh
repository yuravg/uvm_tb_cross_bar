//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_read extends bus_base_seq;
  `uvm_object_utils(bus_read)

  extern function new(string name = "");
  extern task body();

endclass : bus_read


function bus_read::new(string name = "");
  super.new(name);
endfunction : new


task bus_read::body();
  operation = bus_seq_item::READ;
  super.body();
endtask : body
