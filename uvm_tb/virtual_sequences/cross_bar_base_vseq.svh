//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_base_vseq extends uvm_virtual_sequence;
  `uvm_object_utils(cross_bar_base_vseq)

  extern function new(string name = "");

  bus_sequencer mseqr[2];
  bus_sequencer sseqr[2];

  // master side
  bus_transaction send[2];
  // slave side
  bus_ack ack[2];

  extern task pre_start();
  extern task body();

  local static bit ack_launched = 0;
  extern virtual task forever_slave_ack();

  extern virtual function void randomize_req(ref req_t req);

  local static semaphore sema[2];
  extern virtual task init_start();
  extern virtual task init_start_master(int master);

endclass : cross_bar_base_vseq


function cross_bar_base_vseq::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar_base_vseq::pre_start();
  for (int i = 0; i < 2; i++) begin : declaration
    send[i] = bus_transaction::type_id::create($sformatf("send[%0d]", i));
    ack[i] = bus_ack::type_id::create($sformatf("ack[%0d]", i));
    sema[i] = new(1);
  end
  forever_slave_ack();
endtask : pre_start


task cross_bar_base_vseq::body();
  init_start();
endtask : body


task cross_bar_base_vseq::forever_slave_ack();
  if (!ack_launched)
  begin
    ack_launched = 1;
    fork
      forever ack[0].start(sseqr[0]);
      forever ack[1].start(sseqr[1]);
    join_none
  end
endtask : forever_slave_ack


function void cross_bar_base_vseq::randomize_req(ref req_t req);
  if (!req.randomize() with
      {operation inside {bus_seq_item::READ, bus_seq_item::WRITE};})
    `uvm_fatal(get_type_name(), "randomize() failed")
endfunction : randomize_req


task cross_bar_base_vseq::init_start();
  int i;
  req_t req = req_t::type_id::create("req");
  randomize_req(req);
  i = req.master;
  case (i)
    0: sema[0].get();
    1: sema[1].get();
  endcase
  send[i].req.do_copy(req);
  send[i].start(mseqr[i]);
  case (i)
    0: sema[0].put();
    1: sema[1].put();
  endcase
endtask : init_start


task cross_bar_base_vseq::init_start_master(int master);
  int i;
  req_t req = req_t::type_id::create("req");
  randomize_req(req);
  i = master;
  case (i)
    0: sema[0].get();
    1: sema[1].get();
  endcase
  send[i].req.do_copy(req);
  send[i].start(mseqr[i]);
  case (i)
    0: sema[0].put();
    1: sema[1].put();
  endcase
endtask : init_start_master
