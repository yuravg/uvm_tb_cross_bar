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

  bus_seq_item item;

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
  item = bus_seq_item::type_id::create("item", this);

  while (~vif.ack) begin
    for (int i = 0; i < 2; i++) begin : vif_master
      item.addr  = vif.addr;
      item.wdata = vif.wdata;
      cmd        = vif.cmd;
    end
    @(posedge vif.clk);
  end
  item.operation = item.cmd2operation(cmd);

  if (item.read_operation()) begin
    while (~vif.resp)
      @(posedge vif.clk);
    item.rdata = vif.rdata;
  end

  ap.write(item);
  @(posedge vif.clk);
endtask : master_bus


task bus_monitor::slave_bus();
  bit cmd;
  item = bus_seq_item::type_id::create("item", this);

  while (~vif.ack) begin
    for (int i = 0; i < 2; i++) begin : vif_save
      item.addr  = vif.addr;
      item.wdata = vif.wdata;
      cmd        = vif.cmd;
    end
    @(negedge vif.clk);
  end
  item.operation = item.cmd2operation(cmd);

  if (item.read_operation()) begin
    while (~vif.resp)
      @(negedge vif.clk);
    item.rdata = vif.rdata;
  end

  ap.write(item);
  @(negedge vif.clk);
endtask : slave_bus
