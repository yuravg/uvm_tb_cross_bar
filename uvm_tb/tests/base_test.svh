//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);

  vif_handles vif_h;
  bus_config magt_cfg[2];
  bus_config sagt_cfg[2];
  env_config env_cfg;
  env        e;

  env_scoreboard_config scrb_cfg;

  cross_bar_base_vseq vseq;

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : base_test


function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void base_test::build_phase(uvm_phase phase);
  vif_h   = vif_handles::type_id::create("vif_h", this);
  env_cfg = env_config::type_id::create("env_cfg", this);
  e       = env::type_id::create("e", this);

  for (int i = 0; i < 2; i++) begin
    magt_cfg[i] = bus_config::type_id::create($sformatf("magt_cfg[%0d]", i), this);
    sagt_cfg[i] = bus_config::type_id::create($sformatf("sagt_cfg[%0d]", i), this);
  end

  if (!uvm_config_db #(vif_handles)::get(this, "", "vif_handles", vif_h)) begin
    `uvm_fatal("build_phase", "Cannot get() vif_handles from uvm_config_db")
  end

  for (int i = 0; i < 2; i++) begin
    magt_cfg[i].vif = vif_h.mbus[i];
    sagt_cfg[i].vif = vif_h.sbus[i];

    sagt_cfg[i].driver_mode = ACK;

    env_cfg.magt_cfg[i] = magt_cfg[i];
    env_cfg.sagt_cfg[i] = sagt_cfg[i];
  end

  uvm_config_db #(env_config)::set(this, "*", "env_config", env_cfg);

  scrb_cfg = env_scoreboard_config::type_id::create("scrb_cfg", this);
  uvm_config_db #(env_scoreboard_config)::set(this, "*", "config", scrb_cfg);

  vseq = cross_bar_base_vseq::type_id::create("vseq");
endfunction : build_phase


task base_test::run_phase(uvm_phase phase);
  for (int i = 0; i < 2; i++) begin
    vseq.mseqr[i] = e.magt[i].seqr;
    vseq.sseqr[i] = e.sagt[i].seqr;
  end

  phase.raise_objection(this);

  @(posedge magt_cfg[0].vif.clk);
  while (magt_cfg[0].vif.reset)
    @(posedge magt_cfg[0].vif.clk);
  @(posedge magt_cfg[0].vif.clk);

  phase.drop_objection(this);
endtask : run_phase
