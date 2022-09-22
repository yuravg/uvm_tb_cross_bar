//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_monitor extends uvm_monitor;
  `uvm_component_utils(bus_monitor)

  uvm_analysis_port #(bus_seq_item) ap;

  driver_mode_e driver_mode = NORMAL;
  bus_vif vif;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  bus_seq_item req;

  extern task run_phase(uvm_phase phase);
  extern task master_bus();
  extern task slave_bus();

endclass : bus_monitor


function bus_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void bus_monitor::build_phase(uvm_phase phase);
  ap = new("ap", this);
endfunction : build_phase


task bus_monitor::run_phase(uvm_phase phase);
  @(posedge vif.clk);
  while (vif.reset)
    @(posedge vif.clk);

  if (driver_mode)
    forever master_bus();
  else
    forever slave_bus();
endtask : run_phase


task bus_monitor::master_bus();
  bit cmd;
  req = bus_seq_item::type_id::create("req", this);

  while (~vif.ack) begin
    for (int i = 0; i < 2; i++) begin : vif_master
      req.addr  = vif.addr;
      req.wdata = vif.wdata;
      cmd        = vif.cmd;
    end
    @(posedge vif.clk);
  end
  req.operation = req.cmd2operation(cmd);

  if (req.read_operation()) begin
    while (~vif.resp)
      @(posedge vif.clk);
    req.rdata = vif.rdata;
  end

  ap.write(req);
  @(posedge vif.clk);
endtask : master_bus


task bus_monitor::slave_bus();
  bit cmd;
  req = bus_seq_item::type_id::create("req", this);

  while (~vif.ack) begin
    for (int i = 0; i < 2; i++) begin : vif_save
      req.addr  = vif.addr;
      req.wdata = vif.wdata;
      cmd        = vif.cmd;
    end
    @(negedge vif.clk);
  end
  req.operation = req.cmd2operation(cmd);

  if (req.read_operation()) begin
    while (~vif.resp)
      @(negedge vif.clk);
    req.rdata = vif.rdata;
  end

  ap.write(req);
  @(negedge vif.clk);
endtask : slave_bus
