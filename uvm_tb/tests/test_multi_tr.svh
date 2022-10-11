//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_multi_tr extends base_test;
  `uvm_component_utils(test_multi_tr)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : test_multi_tr


function test_multi_tr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void test_multi_tr::build_phase(uvm_phase phase);
  cross_bar_base_vseq::type_id::set_type_override(cross_bar_multi_tr::get_type());
  super.build_phase(phase);
endfunction : build_phase


task test_multi_tr::run_phase(uvm_phase phase);
  int num;
  super.run_phase(phase);

  num = $urandom_range(2, 4);
  phase.raise_objection(this);
  repeat (num) begin
    vseq.start(null);
  end
  phase.drop_objection(this);
endtask : run_phase
