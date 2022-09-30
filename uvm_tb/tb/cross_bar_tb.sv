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

  vif_handles vif_h;

  initial begin
    vif_h = vif_handles::type_id::create("vif_h");

    vif_h.mbus[0] = mbus[0];
    vif_h.mbus[1] = mbus[1];
    vif_h.sbus[0] = sbus[0];
    vif_h.sbus[1] = sbus[1];

	  uvm_config_db #(vif_handles)::set(null, "uvm_test_top", "vif_handles", vif_h);
    run_test();
  end

endmodule : cross_bar_tb
