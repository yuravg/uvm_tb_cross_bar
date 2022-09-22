//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar2bus_seq extends uvm_sequence #(bus_seq_item);
  `uvm_object_utils(cross_bar2bus_seq)

  extern function new(string name = "");

  cross_bar_sequencer seqr;

  extern virtual task body();

endclass : cross_bar2bus_seq


function cross_bar2bus_seq::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar2bus_seq::body();
  cross_bar_seq_item cb_req;
  bus_seq_item       bus_req;

  forever begin
    seqr.get_next_item(cb_req);

    bus_req = bus_seq_item::type_id::create("bus_req",, get_full_name());
    start_item(bus_req);

    // bus_req.addr      = cb_req.addr;
    // bus_req.wdata     = cb_req.wdata;
    // bus_req.operation = cb_req.operation;

    // cb_req.rdata      = bus_req.rdata;

    finish_item(bus_req);
    seqr.item_done();
  end
endtask : body
