//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_transaction extends cross_bar_base_vseq;
  `uvm_object_utils(cross_bar_transaction)

  extern function new(string name = "");
  extern virtual task body();

endclass : cross_bar_transaction


function cross_bar_transaction::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar_transaction::body();
  repeat (num_sequences) begin
    assert(item.randomize() with {operation==item_t::READ || operation==item_t::WRITE;});
    transaction(item);
  end
endtask : body
