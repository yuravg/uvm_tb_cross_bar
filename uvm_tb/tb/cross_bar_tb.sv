//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

import uvm_pkg::*;

import test_pkg::*;
import bus_agent_pkg::bus_vif;

`define CLK125 8ns

module cross_bar_tb();

  logic clk;
  logic reset;

  bus_if mbus[2]();
  bus_if sbus[2]();

  cross_bar DUT(
    .clk   (clk  ),
    .reset (reset),
    .mbus  (mbus ),
    .sbus  (sbus )
  );

  genvar i;
  for (i = 0; i < 2; i++) begin
    assign mbus[i].clk   = clk;
    assign mbus[i].reset = reset;
    assign sbus[i].clk   = clk;
    assign sbus[i].reset = reset;
  end

  initial begin
    clk <= 0;
    forever #(`CLK125/2) clk = ~clk;
  end

  initial begin
    reset <= 1;
    repeat (10) @(posedge clk);
    reset <= 0;
  end

  initial begin
    uvm_config_db #(bus_vif)::set(null, "uvm_test_top", "mbus0_vif", mbus[0]);
    uvm_config_db #(bus_vif)::set(null, "uvm_test_top", "mbus1_vif", mbus[1]);
    uvm_config_db #(bus_vif)::set(null, "uvm_test_top", "sbus0_vif", sbus[0]);
    uvm_config_db #(bus_vif)::set(null, "uvm_test_top", "sbus1_vif", sbus[1]);
    run_test();
  end

endmodule : cross_bar_tb
