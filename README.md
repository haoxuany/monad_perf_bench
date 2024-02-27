So far:

```
dune exec monad_perf_bench -- -ascii
Estimated testing time 1m40s (10 benchmarks x 10s). Change using '-quota'.

Name                         Time/Run      mWd/Run   mjWd/Run   Prom/Run   Percentage
---------------------------- ---------- ------------ ---------- ---------- ------------
no monad                       2.22us    5_997.03w                              5.45%
imperative                     4.44us    3_003.05w      0.14w      0.14w       10.90%
imperative (split product)     1.43us        8.99w                              3.50%
iter library                   4.84us    4_014.88w      0.23w      0.23w       11.86%
prod                          40.77us   67_964.68w    199.09w    199.09w      100.00%
prod inline                   38.26us   67_962.62w    191.82w    191.82w       93.85%
prod inline boxed             40.35us   67_963.10w    197.39w    197.38w       98.99%
cont                          29.80us   71_963.43w    900.34w    900.35w       73.09%
cont unbox                    30.07us   71_963.00w    900.30w    900.28w       73.76%
cont inline unbox             29.86us   71_963.22w    900.61w    900.59w       73.23%
```
