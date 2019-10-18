//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_idle extends bus_base_seq;
  `uvm_object_utils(bus_idle)

  extern function new(string name = "");
  extern task body();

endclass : bus_idle


function bus_idle::new(string name = "");
  super.new(name);
endfunction : new


task bus_idle::body();
  item.operation = bus_seq_item::IDLE;
  super.body();
endtask : body
