//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);

  bus_config magt_cfg[2];
  bus_config sagt_cfg[2];
  env_config env_cfg;
  env        e;

  env_scoreboard_config scrb_cfg;

  cross_bar_write       write;
  cross_bar_read        read;
  cross_bar_transaction tr;
  cross_bar_multi_tr    mtr;

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : base_test


function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void base_test::build_phase(uvm_phase phase);
  for (int i = 0; i < 2; i++) begin
    magt_cfg[i] = bus_config::type_id::create($sformatf("magt_cfg[%0d]", i), this);
    sagt_cfg[i] = bus_config::type_id::create($sformatf("sagt_cfg[%0d]", i), this);
  end

  env_cfg = env_config::type_id::create("env_cfg", this);
  e       = env::type_id::create("e", this);

  for (int i = 0; i < 2; i++) begin
    if (!uvm_config_db #(bus_vif)::get(this, "", $sformatf("mbus%0d_vif", i), magt_cfg[i].vif)) begin
      `uvm_fatal("build_phase", "Unable to get mbus[i]_vif (type: bus_vif) from uvm_config_db")
    end
    if (!uvm_config_db #(bus_vif)::get(this, "", $sformatf("sbus%0d_vif", i), sagt_cfg[i].vif)) begin
      `uvm_fatal("build_phase", "Unable to get sbus[i]_vif (type: bus_vif) from uvm_config_db")
    end

    sagt_cfg[i].driver_mode = ACK;

    env_cfg.magt_cfg[i] = magt_cfg[i];
    env_cfg.sagt_cfg[i] = sagt_cfg[i];
  end

  uvm_config_db #(env_config)::set(this, "*", "env_config", env_cfg);

  scrb_cfg = env_scoreboard_config::type_id::create("scrb_cfg", this);
  uvm_config_db #(env_scoreboard_config)::set(this, "*", "config", scrb_cfg);

  write = cross_bar_write::type_id::create("write");
  read  = cross_bar_read::type_id::create("read");
  tr    = cross_bar_transaction::type_id::create("tr");
  mtr   = cross_bar_multi_tr::type_id::create("mtr");

  // NOTE: overwrite type bus_seq_item
  // bus_seq_item::type_id::set_type_override(cross_bar_seq_item::get_type());

  // set_report_verbosity_level_hier(UVM_HIGH);
endfunction : build_phase


task base_test::run_phase(uvm_phase phase);
  for (int i = 0; i < 2; i++) begin
    write.mseqr[i] = e.magt[i].seqr;
    write.sseqr[i] = e.sagt[i].seqr;
    read.mseqr[i]  = e.magt[i].seqr;
    read.sseqr[i]  = e.sagt[i].seqr;
    tr.mseqr[i]    = e.magt[i].seqr;
    tr.sseqr[i]    = e.sagt[i].seqr;
    mtr.mseqr[i]   = e.magt[i].seqr;
    mtr.sseqr[i]   = e.sagt[i].seqr;
  end

  phase.raise_objection(this);

  @(posedge magt_cfg[0].vif.clk);
  while (magt_cfg[0].vif.reset)
    @(posedge magt_cfg[0].vif.clk);
  @(posedge magt_cfg[0].vif.clk);

  phase.drop_objection(this);
endtask : run_phase
