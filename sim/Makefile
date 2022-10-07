
MAKE = make --no-print-directory

VLOG_OPTIONS = -incr -sv +acc -timescale 1ns/1ps
VSIM_OPTIONS =
VLOG = vlog $(VLOG_OPTIONS)
VSIM_MODE ?= "-c"
END_TIME_VSIM ?= 1ms
WRITE_RPT ?= "yes"

define vlog_pkg
  $(VLOG) +incdir+$(dir $(basename $1)) $1
endef

UVM_MSG ?= ""
ifeq ($(UVM_MSG), HIGH)
  UVM_VERBOSITY=+UVM_VERBOSITY=UVM_HIGH
else
  UVM_VERBOSITY=+UVM_VERBOSITY=UVM_LOW
endif

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

.PHONY: wlib compile_rtl compile_tb compile opt sim sim_cmd sim_gui write_rpt

wlib:
	@-if [ ! -d work ] ; then \
	  vlib work;              \
	fi
	vmap work work

compile_rtl:
	@$(MAKE) wlib
	$(VLOG) $(RTL)/bus_if_pkg.sv  \
			$(RTL)/bus_if.sv      \
			$(RTL)/bus2bus_mux.sv \
			$(RTL)/$(DUT).sv

compile_tb:
	@$(MAKE) wlib
	$(call vlog_pkg,$(TB)/agents/bus_uvc/bus_agent_pkg.sv)
	$(call vlog_pkg,$(TB)/agents/cross_bar_uvc/cross_bar_agent_pkg.sv)
	$(call vlog_pkg,$(TB)/uvm_tb/virtual_sequences/cross_bar_vseqs_pkg.sv)
	$(call vlog_pkg,$(TB)/uvm_tb/env/env_pkg.sv)
	$(call vlog_pkg,$(TB)/uvm_tb/tests/test_pkg.sv)
	$(VLOG) $(TB)/uvm_tb/tb/cross_bar_tb.sv

compile:
	@$(MAKE) compile_rtl
	@$(MAKE) compile_tb

opt:
	vopt $(DUT)_tb -o $(DUT)_tb_opt

# NOTE: gui do not write rpt file
sim:
	@-if [ "$(VSIM_MODE)" = "-c" ]; then \
		$(MAKE) sim_cmd;                 \
		$(MAKE) write_rpt;               \
	  else                               \
		$(MAKE) sim_gui;                 \
	  fi

sim_cmd:
	vsim -c $(VSIM_OPTIONS) $(DUT)_tb_opt                             \
		+UVM_TESTNAME=$(UVM_TEST) -l $(UVM_TEST).log $(UVM_VERBOSITY) \
		-do "run $(END_TIME_VSIM); exit"

sim_gui:
	vsim $(VSIM_OPTIONS) $(DUT)_tb_opt                                \
		+UVM_TESTNAME=$(UVM_TEST) -l $(UVM_TEST).log $(UVM_VERBOSITY) \
		-do "source ./wave_$(DUT)_tb.do; run $(END_TIME_VSIM)" &

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
	rm -rf *.log *.rpt

clean:
	@$(MAKE) clean_log
	rm -rf *~ work *.wlf* questa.tops transcript *.vstf wlft??????

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

CNT_TESTS=`echo $(TESTS) | wc -w`
CNT_LOG=`ls test_*.log 2>/dev/null | wc -l `
CNT_TEST_DONE=`grep -e '\[TEST_DONE\]     1' test_*.log 2>/dev/null | wc -l `
CNT_TEST_PASSED=`grep -e 'UVM_INFO.*UVM TEST PASSED' test_*.log 2>/dev/null | wc -l `

summary:
	@echo "+-------------------------------------------------------+";                \
	 echo "| Summary:                                              |";                \
	 echo "+-------------------------------------------------------+";                \
	 echo "| Expect tests / Find logs       = $(CNT_TESTS) / $(CNT_LOG)";             \
	 echo "| Tests done   / Tests PASSED    = $(CNT_TEST_DONE) / $(CNT_TEST_PASSED)"; \
	 echo "+-------------------------------------------------------+";
	@-if [ $(CNT_TESTS) -eq $(CNT_LOG) ] &&         \
		 [ $(CNT_TESTS) -eq $(CNT_TEST_DONE) ] &&   \
		 [ $(CNT_TESTS) -eq $(CNT_TEST_PASSED) ] && \
		 [ $(CNT_TESTS) -gt 0 ] ; then              \
		echo "| Finished successfully!";            \
	  else                                          \
		echo "| ERRORS are detected!";              \
	  fi
	@echo "+-------------------------------------------------------+";
