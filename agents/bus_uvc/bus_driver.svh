//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_driver extends uvm_driver #(bus_seq_item);
  `uvm_component_utils(bus_driver)

  bus_vif vif;
  driver_mode_e driver_mode = NORMAL;

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);
  extern task init();
  extern task init_bus_vif();
  extern task bus_idle();
  extern task read(bus_seq_item item);
  extern task write(bus_seq_item item);
  extern protected task ack2operatioin(bus_seq_item item);

endclass : bus_driver


function bus_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


task bus_driver::run_phase(uvm_phase phase);
  bus_seq_item item;
  this.bus_idle();
  forever begin
    seq_item_port.get_next_item(item);
    case (item.operation)
      bus_seq_item::INIT  : bus_idle();
      bus_seq_item::IDLE  : bus_idle();
      bus_seq_item::READ  : read(item);
      bus_seq_item::WRITE : write(item);
      bus_seq_item::ACK   : ack2operatioin(item);
      default : `uvm_error("ERROR", "Can't recognize operation")
    endcase
    seq_item_port.item_done();
  end
endtask : run_phase


task bus_driver::init();
  if ($isunknown(vif.reset)) begin
    `uvm_error("bus", "Detected: vif.reset == x! You must set this net!")
  end
  if ($isunknown(vif.clk)) begin
    `uvm_error("bus", "Detected: vif.clk == x! You must set this net!")
  end
  init_bus_vif();
endtask : init


task bus_driver::init_bus_vif();
  if (driver_mode) begin
    for (int i = 0; i < 2; i++) begin : master_side
      vif.req   = 0;
      vif.addr  = 'hx;
      vif.wdata = 'hx;
      vif.cmd   = 'hx;
    end
  end else begin
    for (int i = 0; i < 2; i++) begin : slave_side
      vif.ack  = 0;
      vif.resp = 0;
    end
  end
endtask : init_bus_vif


task bus_driver::bus_idle();
  init_bus_vif();
  @(posedge vif.clk);
endtask : bus_idle


task bus_driver::read(bus_seq_item item);
  vif.req  = 1;
  vif.addr = item.addr;
  vif.cmd  = 0;
  while (~vif.ack)
    @(posedge vif.clk);
  vif.req = 0;
  while (~vif.resp)
    @(posedge vif.clk);
  item.rdata = vif.rdata;
  init_bus_vif();
  `uvm_info("debug", item.convert2string(), UVM_HIGH)
endtask : read


task bus_driver::write(bus_seq_item item);
  vif.req   = 1;
  vif.addr  = item.addr;
  vif.wdata = item.wdata;
  vif.cmd   = 1;
  while (~vif.ack)
    @(posedge vif.clk);
  init_bus_vif();
  `uvm_info("debug", item.convert2string(), UVM_HIGH)
endtask : write


task bus_driver::ack2operatioin(bus_seq_item item);
  if (driver_mode)
    `uvm_error("ERROR", "Method ack2operatioin() available for driver_mode only!")

  while (~vif.req)
    @(posedge vif.clk);
  repeat ($urandom_range(2, 0)) @(posedge vif.clk);

  fork
    begin
      vif.ack = 1;
      @(posedge vif.clk);
      vif.ack = 0;
    end

    begin
      if (!vif.cmd) begin
        repeat ($urandom_range(2, 0)) @(posedge vif.clk);
        vif.resp = 1;
        vif.rdata = $random;
        item.rdata = vif.rdata;
        @(posedge vif.clk);
        vif.resp = 0;
        vif.rdata = 'hx;
      end
    end
  join

  init_bus_vif();
endtask : ack2operatioin
