//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_base_vseq extends uvm_virtual_sequence;
  `uvm_object_utils(cross_bar_base_vseq)

  extern function new(string name = "");

  item_t item;

  bus_sequencer mseqr[2];
  bus_sequencer sseqr[2];

  // master side
  bus_transaction bus_tr[2];
  // slave side
  bus_ack ack[2];

  rand int num_sequences;
  rand int length [2];

  extern task pre_body();
  extern virtual task body();

  extern task transaction(input item_t item);
  extern task write(input item_t item);
  extern task read(input item_t item);

  extern protected task forever_ack();

endclass : cross_bar_base_vseq


function cross_bar_base_vseq::new(string name = "");
  super.new(name);

  num_sequences = $urandom_range(4, 2);
  for (int i = 0; i < 2; i++) begin
    length[i] = $urandom_range(4, 1);
  end
endfunction : new


task cross_bar_base_vseq::pre_body();
  item = item_t::type_id::create($sformatf("item"));

  for (int i = 0; i < 2; i++) begin : declaration
    bus_tr[i] = bus_transaction::type_id::create($sformatf("bus_tr[%0d]", i));
    ack[i]    = bus_ack        ::type_id::create($sformatf("ack[%0d]",    i));
  end

  fork
    forever_ack();
  join_none
endtask : pre_body


task cross_bar_base_vseq::body();
  super.body();
endtask : body


task cross_bar_base_vseq::transaction(input item_t item);
  int i = item.master;
  bus_tr[i].item.do_copy(item);
  `uvm_info("debug", $sformatf("bus_tr[%0d]: %0s",
                               i, bus_tr[i].item.convert2string()), UVM_HIGH)
  bus_tr[i].start(mseqr[i]);
endtask : transaction


task cross_bar_base_vseq::write(input item_t item);
  item.operation = item_t::WRITE;
  transaction(item);
endtask : write


task cross_bar_base_vseq::read(input item_t item);
  item.operation = item_t::READ;
  transaction(item);
endtask : read


task cross_bar_base_vseq::forever_ack();
  fork
    forever ack[0].start(sseqr[0]);
    forever ack[1].start(sseqr[1]);
  join_any
endtask : forever_ack
