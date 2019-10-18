//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  bus_config magt_cfg[2];
  bus_config sagt_cfg[2];

  function new(string name = "");
    super.new(name);
  endfunction : new

endclass : env_config
