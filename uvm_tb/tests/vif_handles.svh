
class vif_handles extends uvm_object;
  `uvm_object_utils(vif_handles)

  bus_vif mbus[2];
  bus_vif sbus[2];

  function new(string name = "vif_handles");
    super.new(name);
  endfunction : new

endclass : vif_handles
