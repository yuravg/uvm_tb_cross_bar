MAKE = make --no-print-directory

QUIET_OPTION ?= -quiet
SCHEMATIC_OP = -debugdb

VLOG = vlog -incr -sv +acc -timescale 1ns/1ps $(QUIET_OPTION)  +incdir+$(UVM_HOME)/src
VOPT = vopt $(SCHEMATIC_OPTION) $(QUIET_OPTION)

VSIM_MODE ?= "-c"
END_TIME_VSIM ?= 1ms
WRITE_RPT ?= "yes"
VSIM_UVM = +UVM_TESTNAME=$(UVM_TEST) -l $(UVM_TEST).log $(UVM_VERBOSITY) +UVM_NO_RELNOTES

VSIM = $(if $(findstring -c,$(VSIM_MODE)),\
vsim $(VSIM_UVM) $(QUIET_OPTION) -c $(DUT)_tb_opt -do "run $(END_TIME_VSIM); exit",\
vsim $(VSIM_UVM) $(QUIET_OPTION) $(SCHEMATIC_OPTION) $(DUT)_tb_opt -do "source ./wave_$(DUT)_tb.do; onfinish stop; run $(END_TIME_VSIM); wave zoom full;" &)

define vlog_pkg
  $(VLOG) +incdir+$(dir $(basename $1)) $1
endef

UVM_MSG ?= "UVM_LOW"
UVM_VERBOSITY=+UVM_VERBOSITY=$(UVM_MSG)

DUT = cross_bar
UVM_TEST ?= test_write
RTL = ../rtl
TB = ..
TESTS = $(notdir $(basename $(wildcard $(TB)/uvm_tb/tests/test*.svh)))

.PHONY: help target
help:
	@echo ""
	@echo "Usage:  make [target(s)]"
	@echo "where target is any of:"
	@echo ""
	@echo "  compile_rtl - compile all rtl"
	@echo "  compile_tb  - compile all testbench"
	@echo "  compile     - compile all rtl and testbench"
	@echo "  clean       - remove derived files"
	@echo ""
	@echo "  all_tests   - run all uvm tests"
	@echo ""
	@echo " <test_name>  - run single test, list of tests:"
	@echo "$(TESTS)"

.PHONY: compile_rtl compile_tb compile opt sim

compile_rtl:
	@echo "Compiling the RTL..."
	@$(VLOG) \
		$(RTL)/bus_if_pkg.sv  \
		$(RTL)/bus_if.sv      \
		$(RTL)/bus2bus_mux.sv \
		$(RTL)/$(DUT).sv

compile_tb:
	@echo "Compiling the TB..."
	@$(call vlog_pkg,$(TB)/agents/bus_uvc/bus_agent_pkg.sv)
	@$(call vlog_pkg,$(TB)/agents/cross_bar_uvc/cross_bar_agent_pkg.sv)
	@$(call vlog_pkg,$(TB)/uvm_tb/virtual_sequences/cross_bar_vseqs_pkg.sv)
	@$(call vlog_pkg,$(TB)/uvm_tb/env/env_pkg.sv)
	@$(call vlog_pkg,$(TB)/uvm_tb/tests/test_pkg.sv)
	@$(VLOG) $(TB)/uvm_tb/tb/cross_bar_tb.sv

compile:
	@$(MAKE) compile_rtl
	@$(MAKE) compile_tb

opt:
	@echo "Optimizing the TB..."
	@$(VOPT) $(DUT)_tb -o $(DUT)_tb_opt

# NOTE: GUI do not write rpt file

sim:
	@echo "Running simulation..."
	@$(VSIM)
	@-if [ "$(VSIM_MODE)" = "-c" ]; then \
		$(MAKE) write_rpt;               \
	  fi

write_rpt:
	@-if [ "$(WRITE_RPT)" = "yes" ]; then            \
		if [ "$(UVM_TEST)".log = "" ]; then          \
		  exit 1;                                    \
		else                                         \
		  scripts/write_report.pl "$(UVM_TEST)".log; \
		fi                                           \
	  fi

.PHONY: clean_log clean

clean_log:
	@echo "Cleaning logs..."
	@rm -rf *.log *.rpt

clean:
	@$(MAKE) clean_log
	@echo "Cleaning derived files..."
	@rm -rf *~ work *.wlf* questa.tops transcript *.vstf wlft??????

# start compilation and simulation by test name
.PHONY: $(TESTS)

$(TESTS):
	@$(MAKE) all UVM_TEST=$@

.PHONY: all rall

all:
	@$(MAKE) compile
	@$(MAKE) opt
	@$(MAKE) sim

rall:
	@$(MAKE) clean
	@$(MAKE) all

.PHONY: all_tests summary
all_tests:
	@$(MAKE) clean_log
	@$(MAKE) compile
	@$(MAKE) opt
	@$(MAKE) sim UVM_TEST=test_write VSIM_MODE='-c'
	@$(MAKE) sim UVM_TEST=test_read VSIM_MODE='-c'
	@$(MAKE) sim UVM_TEST=test_transaction VSIM_MODE='-c'
	@$(MAKE) sim UVM_TEST=test_multi_tr VSIM_MODE='-c'
	@$(MAKE) sim UVM_TEST=test_arbitrage VSIM_MODE='-c'
	@$(MAKE) summary

summary:
	@cd scripts && ./uvm_summary.pl
