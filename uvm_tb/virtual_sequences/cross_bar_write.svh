//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_write extends cross_bar_base_vseq;
  `uvm_object_utils(cross_bar_write)

  extern function new(string name = "");
  extern virtual task body();

endclass : cross_bar_write


function cross_bar_write::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar_write::body();
  super.body();

  repeat (num_sequences) begin
    if (!req.randomize())
      `uvm_fatal(get_type_name(), "randomize() failed")
    write(req);
  end
endtask : body
