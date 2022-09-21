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
  item_t item[2];
  for (int i = 0; i < 2; i++) begin
    item[i] = item_t::type_id::create($sformatf("item[%0d]", i));
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
        assert(item[0].randomize()
               with {master == 0; operation==item_t::READ || operation==item_t::WRITE;});

        transaction(item[0]);
      end

      repeat (length[1]) begin
        assert(item[1].randomize()
               with {master == 1; operation==item_t::READ || operation==item_t::WRITE;});

        transaction(item[1]);
      end
    join
  end
endtask : body
