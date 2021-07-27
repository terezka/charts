# elm-charts-alpha

This is the nightly version of [`terezka/elm-charts`](https://package.elm-lang.org/packages/terezka/elm-charts/latest/). This has faster updates, but also more breaking changes!

```elm

import Chart as C
import Chart.Attributes as CA

main : Svg msg
main =
  C.chart
    [ CA.height 300
    , CA.width 300
    ]
    [ C.xTicks []
    , C.yTicks []
    , C.xLabels []
    , C.yLabels []
    , C.xAxis []
    , C.yAxis []
    , C.series .x
        [ C.scatter .y []
        , C.scatter .z []
        ]
        data
    ]
```
