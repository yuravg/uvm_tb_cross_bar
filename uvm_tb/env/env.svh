//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class env extends uvm_env;
  `uvm_component_utils(env)

  bus_agent          magt[2];
  bus_agent          sagt[2];
  env_config         env_cfg;
  env_scoreboard     scrb;
  cross_bar_layering master_lrg[2];
  cross_bar_layering slave_lrg[2];

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : env


function env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg)) begin
    `uvm_fatal("build_phase", "Unable to get env_config (type: env_config) from uvm_config_db")
  end

  for (int i = 0; i < 2; i++) begin
    uvm_config_db #(bus_config)::set(this, $sformatf("magt[%0d]*", i), "config",
                                     env_cfg.magt_cfg[i]);
    uvm_config_db #(bus_config)::set(this, $sformatf("sagt[%0d]*", i), "config",
                                     env_cfg.sagt_cfg[i]);

    magt[i] = bus_agent::type_id::create($sformatf("magt[%0d]", i), this);
    sagt[i] = bus_agent::type_id::create($sformatf("sagt[%0d]", i), this);

    master_lrg[i] = cross_bar_layering::type_id::create($sformatf("master_lrg[%0d]", i), this);
    slave_lrg[i]  = cross_bar_layering::type_id::create($sformatf("slave_lrg[%0d]",  i), this);
  end

  scrb = env_scoreboard::type_id::create("scrb", this);
endfunction : build_phase


function void env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  for (int i = 0; i < 2; i++) begin
    master_lrg[i].connect2agent(magt[i]);
    slave_lrg[i].connect2agent(sagt[i]);

    master_lrg[i].set_master_bus_num(i);

    master_lrg[i].ap.connect(scrb.ap_master[i]);
    slave_lrg[i].ap.connect(scrb.ap_slave[i]);
  end
endfunction : connect_phase
