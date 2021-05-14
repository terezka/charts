# elm-charts-alpha

Make charts! Alpha version. Feel free to use, but please do not share publicly yet. Documentation is unfinished/wrong and API liable to breaking changes.

```elm

import Chart as C
import Chart.Attributes as CA

main : Svg msg
main =
  C.chart
    [ CA.height 250
    , CA.width 250
    , CA.static
    ]
    [ C.grid []
    , C.xAxis []
    , C.xLabels []
    , C.yAxis []
    , C.yLabels []
    , C.series .x
        [ C.property .y "y" [] [ CA.size 6, CA.triangle ]
        , C.property .z "z" [] [ CA.size 6, CA.cross ]
        , C.property .v "v" [] [ CA.size 6, CA.square ]
        , C.property .w "w" [] [ CA.size 6, CA.circle ]
        , C.property .p "p" [] [ CA.size 6, CA.diamond ]
        , C.property .q "q" [] [ CA.size 6, CA.plus ]
        ]
        [ { x = 0, y = Just 2, z = Just 3, v = Just 1, w = Just 5, p = Just 4, q = Just 6 }
        , { x = 2, y = Just 1, z = Just 2, v = Just 3, w = Just 4, p = Just 6, q = Just 4 }
        , { x = 5, y = Just 1, z = Just 2, v = Just 3, w = Just 4, p = Just 6, q = Just 4 }
        , { x = 7, y = Just 4, z = Just 5, v = Just 3, w = Just 2, p = Just 7, q = Just 6 }
        , { x = 10, y = Just 4, z = Just 5, v = Just 3, w = Just 2, p = Just 7, q = Just 6 }
        ]
    ]
```