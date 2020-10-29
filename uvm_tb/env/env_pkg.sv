//-----------------------------------------------------------------------------
// Author  : Yuriy Gritsenko
// URL     : https://github.com/yuravg/uvm_tb_cross_bar
// License : MIT License
//-----------------------------------------------------------------------------

`ifndef ENV_PKG_SV
  `define ENV_PKG_SV

package env_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import bus_agent_pkg::*;
  import cross_bar_agent_pkg::*;
  import cross_bar_layering_pkg::*;

  typedef enum {UNDEFINED, ARBITRAGE} test_name_e;
  `include "env_scoreboard_config.svh"
  `include "env_scoreboard.svh"

  `include "env_config.svh"
  `include "tb_env.svh"

endpackage : env_pkg

`endif // ENV_PKG_SV
