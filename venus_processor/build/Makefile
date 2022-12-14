fetch := $(shell ls -d ../fetch/*.v | tr '\n' ' ')
decode := $(shell ls -d ../decode/*.v | tr '\n' ' ')
register := $(shell ls -d ../register/*.v | tr '\n' ' ')
exec := $(shell ls -d ../exec/*.v | tr '\n' ' ')

PYTHON_PATH := $(shell which python)
VERILOG_PATH := $(shell which iverilog)
VERILOG_OPT := -o ./venus_processor_test.out
VERILOG_RUN := ./venus_processor_test.out

ifeq ($(PYTHON_PATH),)
	PYTHON_PATH := $(shell which python3)
endif

ifeq ($(VERILOG_PATH),)
	VERILOG_PATH := $(shell which vcs)
	VERILOG_OPT := "-R"
endif

../mem/memfiles/mem_instruction.dat: ../tests/test.vasm
	$(PYTHON_PATH) ../../vasm/vasm.py $^ > $@

venus_processor_test: ../top_test.v ../top.v ../mem/mem_data.v ../mem/mem_instruction.v $(fetch) $(register) $(decode) $(exec)
	make ../mem/memfiles/mem_instruction.dat
	$(VERILOG_PATH) $(VERILOG_OPT) $^
	$(VERILOG_RUN)

venus_processor: ../top.v ../mem/mem_data.v ../mem/mem_instruction.v $(fetch) $(register) $(decode) $(exec)
	make ../mem/memfiles/mem_instruction.dat
	vcs -R $^

test_exec: ../tests/test_exec.v ../mem/mem_data.v ../mem/mem_instruction.v $(fetch) $(register) $(decode) $(exec)
	make ../mem/memfiles/mem_instruction.dat
	vcs -R $^

test_decode: ../tests/test_decode.v ../mem/test_decode_mem.v $(fetch) $(register) $(decode)
	vcs -R $^

test_fetch: ../tests/test_fetch.v ../mem/DP_mem32x64k.v $(fetch)
	echo $(fetch)
	vcs -R $^

test_mem: ../tests/test_mem.v ../mem/DP_mem32x64k.v
	vcs -R $^