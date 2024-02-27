So far:

```
dune exec monad_perf_bench -- -ascii
Estimated testing time 1m30s (9 benchmarks x 10s). Change using '-quota'.

Name                         Time/Run      mWd/Run   mjWd/Run   Prom/Run   Percentage
---------------------------- ---------- ------------ ---------- ---------- ------------
no monad                       2.22us    5_997.03w                              5.58%
imperative                     5.80us    3_002.92w      0.14w      0.14w       14.58%
imperative (split product)     1.42us        9.04w                              3.57%
prod                          39.79us   67_963.30w    197.23w    197.22w       99.92%
prod inline                   36.68us   67_962.75w    199.31w    199.30w       92.11%
prod inline boxed             39.82us   67_964.81w    188.75w    188.75w      100.00%
cont                          32.52us   71_964.17w    904.95w    904.97w       81.66%
cont unbox                    32.57us   71_964.19w    900.20w    900.21w       81.80%
cont inline unbox             33.90us   71_963.82w    900.69w    900.67w       85.15%
```
