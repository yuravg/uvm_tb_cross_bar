//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_transaction extends base_test;
  `uvm_component_utils(test_transaction)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

endclass : test_transaction


function test_transaction::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task test_transaction::run_phase(uvm_phase phase);
  super.run_phase(phase);

  tr.num_sequences = 10;

  phase.raise_objection(this);
  tr.start(.sequencer(null));
  phase.drop_objection(this);
endtask : run_phase
