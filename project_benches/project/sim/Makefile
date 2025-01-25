export ECE745_PROJECT_HOME ?= $(PWD)/../../..

GEN_TYPE ?= generator
TEST_SEED ?= 123456

include $(ECE745_PROJECT_HOME)/verification_ip/interface_packages/wb_pkg/Makefile
include $(ECE745_PROJECT_HOME)/verification_ip/interface_packages/i2c_pkg/Makefile
include $(ECE745_PROJECT_HOME)/verification_ip/environment_packages/i2cmb_env_pkg/Makefile
include $(ECE745_PROJECT_HOME)/verification_ip/ncsu_pkg/Makefile

CLI_DO_COMMANDS = -do " \
                    set NoQuitOnFinish 1; \
                    run -all; \
	 	            do save_coverage.do $(GEN_TYPE); \
                    quit -f;" 

DEBUG_DO_COMMANDS = -do " \
                    set NoQuitOnFinish 1; \
                    do wave.do;\
                    run -a;"\

all: cli merge_coverage view_coverage

clean: 
	rm -rf work *.wlf transcript qrun.out *.ucdb *.log design.bin qwave.db

comp_I2C_MB:
	vcom -cover sbcef ../rtl/iicmb_int_pkg.vhd
	vcom -cover sbcef ../rtl/iicmb_pkg.vhd
	vcom -cover sbcef ../rtl/mbyte.vhd
	vcom -cover sbcef ../rtl/mbit.vhd
	vcom -cover sbcef ../rtl/bus_state.vhd
	vcom -cover sbcef ../rtl/filter.vhd
	vcom -cover sbcef ../rtl/conditioner.vhd
	vcom -cover sbcef ../rtl/conditioner_mux.vhd
	vcom -cover sbcef ../rtl/iicmb_m.vhd
	vcom -cover sbcef ../rtl/regblock.vhd
	vcom -cover sbcef ../rtl/wishbone.vhd
	vcom -cover sbcef ../rtl/iicmb_m_wb.vhd


comp_bench: comp_ncsu_pkg comp_wb_pkg comp_i2c_pkg comp_i2cmb_pkg
	vlog ../testbench/top.sv

optimize:
	vopt +acc top -o optimized_debug_top_tb

compile: comp_I2C_MB comp_bench optimize

simulate:
	vsim  -i -classdebug -msgmode both -do "set NoQuitOnFinish 1; do wave.do" optimized_debug_top_tb

debug_3step: clean compile simulate

#debug: clean compile
#	qrun -64 -gui -visualizer -onfinish stop -classdebug -uvmcontrol=all -msgmode both -permit_unmatched_virtual_intf -l run.log -f lab1_filelist.f -sv_seed 123456 -msglimit error -msglimitcount 20 -do "set IterationLimit 140000; set NoQuitOnFinish 1; coverage attribute -name TESTNAME -value test_top; coverage save -onexit test_top.ucdb; do wave.do" -debug,livesim -qwavedb=+signal+memory=1024+report+parameter+class+assertion+uvm_schematic+msg+classmemory=1024+statictaskfunc -top top -covermultiuserenv -designfile design.bin &

run_cli:
	#vsim -c -coverage $(CLI_DO_COMMANDS) optimized_debug_top_tb
	vsim -c -coverage -sv_seed $(TEST_SEED) $(CLI_DO_COMMANDS) +GEN_TYPE=$(GEN_TYPE) optimized_debug_top_tb

run_gui:
	vsim -coverage $(DEBUG_DO_COMMANDS) optimized_debug_top_tb
	#vsim -coverage -sv_seed $(TEST_SEED) $(DEBUG_DO_COMMANDS) +GEN_TRANS_TYPE=$(GEN_TRANS_TYPE) optimized_debug_top_tb

cli: clean compile optimize
	$(MAKE) run_cli GEN_TYPE=generator_reg_test
	$(MAKE) run_cli GEN_TYPE=generator

debug: clean compile optimize run_gui

merge_coverage:
	xml2ucdb -format Excel ./test_plan_layered_testbench.xml ./test_plan_layered_testbench.ucdb
	vcover merge -stats=none -strip 0 -totals sim_and_testplan_merged.ucdb ./*.ucdb 


view_coverage:
	vsim -viewcov ./sim_and_testplan_merged.ucdb

	
