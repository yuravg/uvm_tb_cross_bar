//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_base_vseq extends uvm_virtual_sequence;
  `uvm_object_utils(cross_bar_base_vseq)

  extern function new(string name = "");

  req_t req;

  bus_sequencer mseqr[2];
  bus_sequencer sseqr[2];

  // master side
  bus_transaction bus_tr[2];
  // slave side
  bus_ack ack[2];

  rand int num_sequences;
  rand int length [2];

  extern virtual task body();

  extern task transaction(input req_t req);
  extern task write(input req_t req);
  extern task read(input req_t req);

  extern protected task forever_ack();

endclass : cross_bar_base_vseq


function cross_bar_base_vseq::new(string name = "");
  super.new(name);

  num_sequences = $urandom_range(4, 2);
  for (int i = 0; i < 2; i++) begin
    length[i] = $urandom_range(4, 1);
  end
endfunction : new


task cross_bar_base_vseq::body();
  req = req_t::type_id::create($sformatf("req"));

  for (int i = 0; i < 2; i++) begin : declaration
    bus_tr[i] = bus_transaction::type_id::create($sformatf("bus_tr[%0d]", i));
    ack[i]    = bus_ack        ::type_id::create($sformatf("ack[%0d]",    i));
  end

  fork
    forever_ack();
  join_none
endtask : body


task cross_bar_base_vseq::transaction(input req_t req);
  int i = req.master;
  bus_tr[i].req.do_copy(req);
  `uvm_info("debug", $sformatf("bus_tr[%0d]: %0s",
                               i, bus_tr[i].req.convert2string()), UVM_HIGH)
  bus_tr[i].start(mseqr[i]);
endtask : transaction


task cross_bar_base_vseq::write(input req_t req);
  req.operation = req_t::WRITE;
  transaction(req);
endtask : write


task cross_bar_base_vseq::read(input req_t req);
  req.operation = req_t::READ;
  transaction(req);
endtask : read


task cross_bar_base_vseq::forever_ack();
  fork
    forever ack[0].start(sseqr[0]);
    forever ack[1].start(sseqr[1]);
  join_any
endtask : forever_ack
