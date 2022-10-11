//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_arbitrage extends cross_bar_base_vseq;
  `uvm_object_utils(cross_bar_arbitrage)

  extern function new(string name = "");
  extern task body();

endclass : cross_bar_arbitrage


function cross_bar_arbitrage::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar_arbitrage::body();
  int num_i = $urandom_range(10, 20);
  int num_j = $urandom_range(4, 7);

  repeat (num_j)
    fork
      repeat (num_i) init_start_master(0);
      repeat (num_i) init_start_master(1);
    join
endtask : body
