test_decode: test_decode.v test_decode_mem.v fetch_instruction.v g_reg_x16.v g_reg_cell.v decode_instruction.v
	vcs -R $^

test_fetch: test_fetch.v DP_mem32x64k.v fetch_instruction.v
	vcs -R $^

test_mem: test_mem.v DP_mem32x64k.v
	vcs -R $^