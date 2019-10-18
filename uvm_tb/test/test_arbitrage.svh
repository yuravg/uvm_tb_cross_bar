//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_arbitrage extends base_test;
  `uvm_component_utils(test_arbitrage)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

endclass : test_arbitrage


function test_arbitrage::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task test_arbitrage::run_phase(uvm_phase phase);
  super.run_phase(phase);

  scrb_cfg.test_name = ARBITRAGE;
  mtr.length_min    = 100;
  mtr.length_max    = 150;
  mtr.lengths_equal = 1;
  mtr.num_sequences = 1;

  phase.raise_objection(this);
  mtr.start(.sequencer(null));
  phase.drop_objection(this);
endtask : run_phase
