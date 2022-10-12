//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

class bus_seq_item extends uvm_sequence_item;
  `uvm_object_utils(bus_seq_item)

  rand bit [31:0] addr;
  rand bit [31:0] wdata;
  rand bit [31:0] rdata;

  typedef enum {INIT, IDLE, READ, WRITE, ACK} operation_e;
  rand operation_e operation;

  extern function new(string name = "");
  extern function string convert2string();
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_record(uvm_recorder recorder);

  extern function operation_e cmd2operation(input bit cmd);
  extern function bit write_operation();
  extern function bit read_operation();

endclass : bus_seq_item


function bus_seq_item::new(string name = "");
  super.new(name);
endfunction : new


function string bus_seq_item::convert2string();
  string s = super.convert2string();
  if (write_operation()) begin
    $sformat(s, "%sWrite (addr data): 0x%04h 0x%04h",
             s, addr, wdata);
  end
  if (read_operation()) begin
    $sformat(s, "%sRead  (addr data): 0x%04h 0x%04h",
             s, addr, rdata);
  end
  return s;
endfunction : convert2string


function void bus_seq_item::do_copy(uvm_object rhs);
  bus_seq_item that;
  if (rhs == null)
    `uvm_error(get_type_name(), "Tried to copy null transaction!")
  super.do_copy(rhs);
  if (!$cast(that,rhs))
    `uvm_error(get_type_name(), "rhs is not a bus_seq_item!")
  addr      = that.addr;
  wdata     = that.wdata;
  rdata     = that.rdata;
  operation = that.operation;
endfunction : do_copy


function bit bus_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  bit data_is_equal;
  bit status;
  bus_seq_item that;
  if (!$cast(that, rhs)) begin
    `uvm_error(get_name(), "rhs is not a bus_seq_item!")
    return 0;
  end
  data_is_equal = (this.write_operation()) ?
                  (this.wdata == that.wdata) :
                  (this.rdata == that.rdata);
  status = super.do_compare(rhs, comparer);
  status &= (this.operation == that.operation);
  status &= (this.addr == that.addr);
  status &= data_is_equal;
  return status;
endfunction : do_compare


function void bus_seq_item::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  `uvm_record_field("addr",      addr)
  `uvm_record_field("wdata",     wdata)
  `uvm_record_field("rdata",     rdata)
  `uvm_record_field("operation", operation.name())
endfunction : do_record


function bus_seq_item::operation_e bus_seq_item::cmd2operation(input bit cmd);
  operation_e op;
  if (cmd)
    op = WRITE;
  else
    op = READ;
  return op;
endfunction : cmd2operation


function bit bus_seq_item::write_operation();
  return (operation == WRITE) ? 1 : 0;
endfunction : write_operation


function bit bus_seq_item::read_operation();
  return (operation == READ) ? 1 : 0;
endfunction : read_operation
