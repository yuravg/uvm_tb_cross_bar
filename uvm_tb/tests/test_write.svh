//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_write extends base_test;
  `uvm_component_utils(test_write)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : test_write


function test_write::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void test_write::build_phase(uvm_phase phase);
  cross_bar_base_vseq::type_id::set_type_override(cross_bar_write::get_type());
  super.build_phase(phase);
endfunction : build_phase


task test_write::run_phase(uvm_phase phase);
  int num;
  super.run_phase(phase);

  num = $urandom_range(5, 10);
  phase.raise_objection(this);
  repeat (num) begin
    vseq.start(null);
  end
  phase.drop_objection(this);
endtask : run_phase
