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
  super.body();

  repeat (num_sequences) begin
    if (!req.randomize() with
        {operation==req_t::READ || operation==req_t::WRITE;})
      `uvm_fatal(get_type_name(), "randomize() failed")
    transaction(req);
  end
endtask : body
