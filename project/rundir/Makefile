all: clean clib compile_rtl compile_test run_sim

compile_all: compile_rtl compile_test

clib:
	vlib ../modules_lib
	vlib ../test_lib
	vmap modules_lib ../modules_lib
	vmap test_lib ../test_lib

compile_rtl:
	vlog -novopt -incr -work ../modules_lib -F ../rtl/rtl.f

compile_test:
	vlog -novopt -incr -work ../test_lib -F ../test/test.f
	
run_sim:
	vsim -novopt +nowarnTSCALE -t 1ps -Lf modules_lib -Lf test_lib -do uart_compile.do test_lib.tb_uart # tb_uart: top entity

clean:
	rm -rf ../modules_lib
	rm -rf ../test_lib