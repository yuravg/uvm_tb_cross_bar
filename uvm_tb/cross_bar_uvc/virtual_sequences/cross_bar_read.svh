//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_read extends cross_bar_base_vseq;
  `uvm_object_utils(cross_bar_read)

  extern function new(string name = "");
  extern virtual task body();

endclass : cross_bar_read


function cross_bar_read::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar_read::body();
  repeat (num_sequences) begin
    assert(item.randomize());
    read(item);
  end
endtask : body
