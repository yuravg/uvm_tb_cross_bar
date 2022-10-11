//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class test_arbitrage extends base_test;
  `uvm_component_utils(test_arbitrage)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : test_arbitrage


function test_arbitrage::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void test_arbitrage::build_phase(uvm_phase phase);
  cross_bar_base_vseq::type_id::set_type_override(cross_bar_arbitrage::get_type());
  super.build_phase(phase);
endfunction : build_phase


task test_arbitrage::run_phase(uvm_phase phase);
  super.run_phase(phase);

  scrb_cfg.test_name = ARBITRAGE;

  phase.raise_objection(this);
  vseq.start(null);
  phase.drop_objection(this);
endtask : run_phase
