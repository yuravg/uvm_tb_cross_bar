//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class env_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(env_scoreboard)

  uvm_analysis_export #(cross_bar_seq_item) ap_master[2];
  uvm_analysis_export #(cross_bar_seq_item) ap_slave[2];

  uvm_tlm_analysis_fifo #(cross_bar_seq_item) ap_master_fifo[2];
  uvm_tlm_analysis_fifo #(cross_bar_seq_item) ap_slave_fifo[2];

  uvm_tlm_analysis_fifo #(cross_bar_seq_item) master_fifo;
  uvm_tlm_analysis_fifo #(cross_bar_seq_item) slave_fifo;

  env_scoreboard_config cfg;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

  int cnt_master_tr = 0;
  int cnt_slave_tr = 0;
  int cnt_errors = 0;
  int cnt_equal = 0;
  bit master = 0;

  extern task run_phase(uvm_phase phase);
  extern task compare_result();
  extern function void report_phase(uvm_phase phase);
  extern protected function bit check_arbitrage(cross_bar_seq_item req, input bit master);

endclass : env_scoreboard


function env_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void env_scoreboard::build_phase(uvm_phase phase);
  if (!uvm_config_db #(env_scoreboard_config)::get(this, "", "config", cfg)) begin
	  `uvm_fatal("build_phase", "Unable to get config (type: env_scoreboard_config) from uvm_config_db")
  end

  for (int i = 0; i < 2; i++) begin
    ap_master[i] = new($sformatf("ap_master[%0d]", i), this);
    ap_slave[i]  = new($sformatf("ap_slave[%0d]", i), this);

    ap_master_fifo[i] = new($sformatf("ap_master_fifo[%0d]", i), this);
    ap_slave_fifo[i]  = new($sformatf("ap_slave_fifo[%0d]", i), this);
  end

  master_fifo = new("master_fifo", this);
  slave_fifo  = new("slave_fifo", this);
endfunction : build_phase


function void env_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  for (int i = 0; i < 2; i++) begin
    ap_master[i].connect(ap_master_fifo[i].analysis_export);
    ap_slave[i].connect(ap_slave_fifo[i].analysis_export);
  end
endfunction : connect_phase


task env_scoreboard::run_phase(uvm_phase phase);
  cross_bar_seq_item master_req = cross_bar_seq_item::type_id::create("master_req", this);
  cross_bar_seq_item slave_req  = cross_bar_seq_item::type_id::create("slave_req", this);

  fork
    forever begin
      ap_master_fifo[0].get(master_req);
      master_fifo.write(master_req);
      `uvm_info("cross_bar", {"Master: ", master_req.convert2string()}, UVM_MEDIUM)
      cnt_master_tr++;
    end

    forever begin
      ap_master_fifo[1].get(master_req);
      master_fifo.write(master_req);
      `uvm_info("cross_bar", {"Master: ", master_req.convert2string()}, UVM_MEDIUM)
      cnt_master_tr++;
    end

    forever begin
      ap_slave_fifo[0].get(slave_req);
      slave_fifo.write(slave_req);
      `uvm_info("cross_bar", {"Slave: ", slave_req.convert2string()}, UVM_MEDIUM)
      cnt_slave_tr++;
    end

    forever begin
      ap_slave_fifo[1].get(slave_req);
      slave_fifo.write(slave_req);
      `uvm_info("cross_bar", {"Slave: ", slave_req.convert2string()}, UVM_MEDIUM)
      cnt_slave_tr++;
    end

    forever begin
      compare_result();
    end
  join
endtask : run_phase


task env_scoreboard::compare_result();
  cross_bar_seq_item mfifo_req = cross_bar_seq_item::type_id::create("mfifo_req", this);
  cross_bar_seq_item sfifo_req = cross_bar_seq_item::type_id::create("sfifo_req", this);

  master_fifo.get(mfifo_req);
  slave_fifo.get(sfifo_req);

  if (mfifo_req.compare(sfifo_req)) begin
    `uvm_info("cross_bar", {"Transaction was completed successfully! ", mfifo_req.convert2string()}, UVM_LOW)
    cnt_equal++;
  end else begin
    `uvm_info("cross_bar", "Verification ERROR!", UVM_LOW)
    `uvm_info("cross_bar", $sformatf("get from master(error): %0s", mfifo_req.convert2string()), UVM_LOW)
    `uvm_info("cross_bar", $sformatf("get from slave (error): %0s", sfifo_req.convert2string()), UVM_LOW)
    cnt_errors++;
  end

  if (cfg.test_name == ARBITRAGE) begin
    if (!check_arbitrage(mfifo_req, master)) begin
      `uvm_info("cross_bar", "Verification ERROR!", UVM_LOW)
      `uvm_info("cross_bar", $sformatf("Arbitrage mismatch: get %0d, expect: %0d",
                                       mfifo_req.master, master), UVM_LOW)
      cnt_errors++;
    end
    master += 1;
  end
endtask : compare_result


function void env_scoreboard::report_phase(uvm_phase phase);
  string summary;
  bit    test_is_ok;
  test_is_ok = (!cnt_errors) && (cnt_equal > 0) &&
               (cnt_equal == cnt_master_tr) && (cnt_master_tr == cnt_slave_tr);
  summary = $sformatf("Success/Error: %0d/%0d; Send/Get: %0d/%0d",
                      cnt_equal, cnt_errors, cnt_master_tr, cnt_slave_tr);
  if (test_is_ok)
    `uvm_info("cross_bar", $sformatf("=== TEST PASSED (%s) ===", summary), UVM_LOW)
  else
    `uvm_info("cross_bar", $sformatf("=== TEST FAILED (%s) ===", summary), UVM_LOW)
endfunction : report_phase


function bit env_scoreboard::check_arbitrage(cross_bar_seq_item req, input bit master);
  if (req.master != master)
    return 0;
  else
    return 1;
endfunction : check_arbitrage
