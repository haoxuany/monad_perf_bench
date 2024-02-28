So far:

```
Estimated testing time 3.5999999999999996s (12 benchmarks x 300ms). Change using '-quota'.

Name                                Time/Run    mWd/Run     mjWd/Run     Prom/Run   Percentage
----------------------------------- ---------- ---------- ------------ ------------ ------------
no monad                             21.74us    48.01kw                                 10.01%
imperative                           43.69us    24.10kw        1.17w        1.17w       20.11%
imperative (split product)           11.73us                                             5.40%
iter library                          7.76us    32.02kw                                  3.57%
prod                                210.72us   368.10kw    1_952.74w    1_952.73w       96.97%
prod inline                         207.19us   368.10kw    1_952.74w    1_952.73w       95.34%
prod inline boxed                   206.97us   368.10kw    1_952.74w    1_952.73w       95.24%
prod manual inline                   40.42us    79.97kw                                 18.60%
prod manual inline (eta expanded)    21.42us    48.05kw                                  9.86%
cont                                217.31us   288.35kw   27_797.00w   27_793.59w      100.00%
cont unbox                          212.20us   288.30kw   26_230.20w   26_221.42w       97.65%
cont inline unbox                   210.57us   288.30kw   25_504.90w   25_499.19w       96.90%
```
