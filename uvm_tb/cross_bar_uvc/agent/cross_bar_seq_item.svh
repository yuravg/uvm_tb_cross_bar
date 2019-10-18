//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class cross_bar_seq_item extends bus_seq_item;
  `uvm_object_utils(cross_bar_seq_item)

  rand bit master;

  extern function new(string name = "");
  extern function int get_slave_item();
  extern function string convert2string();
  extern function void do_record(uvm_recorder recorder);
  extern virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_copy(uvm_object rhs);

endclass : cross_bar_seq_item


function cross_bar_seq_item::new(string name = "");
  super.new(name);
endfunction : new


function int cross_bar_seq_item::get_slave_item();
  return addr[31];
endfunction : get_slave_item


function string cross_bar_seq_item::convert2string();
  string s = super.convert2string();
  int slave = get_slave_item();
  if (write_operation()) begin
    $sformat(s, "%s (master #%0d, slave #%0d)",
             s, master, slave);
  end
  if (read_operation()) begin
    $sformat(s, "%s (master #%0d, slave #%0d)",
             s, master, slave);
  end
  return s;
endfunction : convert2string


function void cross_bar_seq_item::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  `uvm_record_field("master", master)
endfunction : do_record


function bit cross_bar_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  cross_bar_seq_item that;
  bit this_slave;
  bit that_slave;
  if (!$cast(that, rhs)) begin
    `uvm_error(get_name(), "rhs is not a cross_bar_seq_item!")
    return 0;
  end
  this_slave = this.get_slave_item();
  that_slave = that.get_slave_item();
  return (super.do_compare(rhs, comparer) &&
          // this.master == that.master &&
          this_slave  == that_slave);
endfunction : do_compare


function void cross_bar_seq_item::do_copy(uvm_object rhs);
  cross_bar_seq_item that;
  assert(rhs != null) else
    `uvm_error(get_name(), "Tried to copy null transaction!")
  super.do_copy(rhs);
  assert($cast(that,rhs)) else
    `uvm_error(get_name(), "rhs is not a bus_seq_item!")
  master = that.master;
endfunction : do_copy
