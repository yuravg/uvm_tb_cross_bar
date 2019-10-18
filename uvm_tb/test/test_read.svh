//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_read extends base_test;
  `uvm_component_utils(test_read)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

endclass : test_read


function test_read::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task test_read::run_phase(uvm_phase phase);
  super.run_phase(phase);

  read.num_sequences = 10;

  phase.raise_objection(this);
  read.start(.sequencer(null));
  phase.drop_objection(this);
endtask : run_phase
