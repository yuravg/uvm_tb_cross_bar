//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_transaction extends base_test;
  `uvm_component_utils(test_transaction)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : test_transaction


function test_transaction::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void test_transaction::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase


task test_transaction::run_phase(uvm_phase phase);
  int num;
  super.run_phase(phase);

  num = $urandom_range(10, 20);
  phase.raise_objection(this);
  repeat (num) begin
    vseq.start(null);
  end
  phase.drop_objection(this);
endtask : run_phase
