# Charts

Some helpers to make charts with.

```elm

planeFromPoints : List Point -> Plane
planeFromPoints points =
  { x =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = minimum .x points
    , max = maximum .x points
    }
  , y =
    { marginLower = 10
    , marginUpper = 10
    , length = 300
    , min = minimum .y points
    , max = maximum .y points
    }
  }

main : Svg msg
main =
  let plane = planeFromPoints data in
  svg
    [ width (String.fromFloat plane.x.length)
    , height (String.fromFloat plane.x.length)
    ]
    [ linear plane .x .y [ stroke blueStroke ] clear data
    , fullHorizontal plane [] 0
    , fullVertical plane [] 0
    , xTicks plane 5 [] 0 [ 1, 2, 3 ]
    , yTicks plane 5 [] 0 [ 1, 2, 3, 5, 6 ]
    , xLabels plane (xLabel "blue" String.fromFloat) 0 [ 1, 2, 3, 5, 10 ]
    , yLabels plane (yLabel "green" String.fromFloat) 0 [ 1, 2, 3, 5, 6 ]
    ]
```

See more examples in the examples folder.