//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_multi_tr extends cross_bar_base_vseq;
  `uvm_object_utils(cross_bar_multi_tr)

  int length_min    = 1;
  int length_max    = 4;
  bit lengths_equal = 0;

  extern function new(string name = "");
  extern virtual task body();

endclass : cross_bar_multi_tr


function cross_bar_multi_tr::new(string name = "");
  super.new(name);
endfunction : new


task cross_bar_multi_tr::body();
  req_t req[2];
  for (int i = 0; i < 2; i++) begin
    req[i] = req_t::type_id::create($sformatf("req[%0d]", i));
  end

  repeat (num_sequences) begin
    if (lengths_equal) begin
      length[0] = $urandom_range(length_max, length_min);
      length[1] = length[0];
    end else begin
      length[0] = $urandom_range(length_max, length_min);
      length[1] = $urandom_range(length_max, length_min);
    end

    fork
      // TODO: use 'for' to create threads(how?)
      repeat (length[0]) begin
        assert(req[0].randomize()
               with {master == 0; operation==req_t::READ || operation==req_t::WRITE;});

        transaction(req[0]);
      end

      repeat (length[1]) begin
        assert(req[1].randomize()
               with {master == 1; operation==req_t::READ || operation==req_t::WRITE;});

        transaction(req[1]);
      end
    join
  end
endtask : body
