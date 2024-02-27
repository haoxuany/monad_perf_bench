So far:

```
dune exec monad_perf_bench -- -ascii
Estimated testing time 1m10s (7 benchmarks x 10s). Change using '-quota'.

Name                Time/Run   mWd/Run   mjWd/Run   Prom/Run   Percentage
------------------- ---------- --------- ---------- ---------- ------------
no monad              2.02us    6.00kw                              4.76%
prod                 38.93us   67.96kw    196.35w    196.35w       91.89%
prod inline          42.37us   67.96kw    200.51w    200.51w      100.00%
prod inline boxed    39.30us   67.96kw    197.15w    197.15w       92.77%
cont                 29.85us   71.96kw    902.59w    902.58w       70.45%
cont unbox           30.06us   71.96kw    902.38w    902.39w       70.95%
cont inline unbox    29.84us   71.96kw    905.08w    905.06w       70.43%
```
