//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_write extends base_test;
  `uvm_component_utils(test_write)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

endclass : test_write


function test_write::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task test_write::run_phase(uvm_phase phase);
  super.run_phase(phase);

  write.num_sequences = 10;

  phase.raise_objection(this);
  write.start(.sequencer(null));
  phase.drop_objection(this);
endtask : run_phase
