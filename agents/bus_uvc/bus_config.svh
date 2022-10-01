//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_config extends uvm_object;
  `uvm_object_utils(bus_config)

  bus_vif vif;
  driver_mode_e driver_mode = SEND;

  extern function new(string name = "");

endclass : bus_config


function bus_config::new(string name = "");
  super.new(name);
endfunction : new
