//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class env_scoreboard_config extends uvm_object;
  `uvm_object_utils(env_scoreboard_config)

  test_name_enum test_name = UNDEFINED;

  extern function new(string name = "");

endclass : env_scoreboard_config


function env_scoreboard_config::new(string name = "");
  super.new(name);
endfunction : new
