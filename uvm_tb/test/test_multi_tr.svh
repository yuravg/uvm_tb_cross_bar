//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_multi_tr extends base_test;
  `uvm_component_utils(test_multi_tr)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

endclass : test_multi_tr


function test_multi_tr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task test_multi_tr::run_phase(uvm_phase phase);
  super.run_phase(phase);

  mtr.num_sequences = 10;

  phase.raise_objection(this);
  mtr.start(.sequencer(null));
  phase.drop_objection(this);
endtask : run_phase
