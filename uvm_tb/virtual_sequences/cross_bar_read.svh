//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_read extends cross_bar_base_vseq;
  `uvm_object_utils(cross_bar_read)

  extern function new(string name = "");
  extern virtual function void randomize_req(ref req_t req);

endclass : cross_bar_read


function cross_bar_read::new(string name = "");
  super.new(name);
endfunction : new


function void cross_bar_read::randomize_req(ref req_t req);
  if (!req.randomize() with
      {operation == bus_seq_item::READ;})
    `uvm_fatal(get_type_name(), "randomize() failed")
endfunction : randomize_req
