
build:
	dune build -w

run:
	dune exec monad_perf_bench -- -ascii -quota 300ms

release:
	dune exec --profile release monad_perf_bench -- -ascii -quota 300ms
