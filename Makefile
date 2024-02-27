
build:
	dune build -w

run:
	dune exec monad_perf_bench -- -ascii
