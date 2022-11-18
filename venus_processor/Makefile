fetch := $(shell ls -d fetch/*.v | tr '\n' ' ')
decode := $(shell ls -d decode/*.v | tr '\n' ' ')
register := $(shell ls -d register/*.v | tr '\n' ' ')
exec := $(shell ls -d exec/*.v | tr '\n' ' ')

mem/memfiles/mem_instruction.dat: tests/test.vasm
	python ../vasm/vasm.py $^ > $@

venus_processor: top.v mem/mem_data.v mem/mem_instruction.v $(fetch) $(register) $(decode) $(exec)
	make mem/memfiles/mem_instruction.dat
	vcs -R $^

test_exec: tests/test_exec.v mem/mem_data.v mem/mem_instruction.v $(fetch) $(register) $(decode) $(exec)
	make mem/memfiles/mem_instruction.dat
	vcs -R $^

test_decode: tests/test_decode.v mem/test_decode_mem.v $(fetch) $(register) $(decode)
	vcs -R $^

test_fetch: tests/test_fetch.v mem/DP_mem32x64k.v $(fetch)
	echo $(fetch)
	vcs -R $^

test_mem: tests/test_mem.v mem/DP_mem32x64k.v
	vcs -R $^