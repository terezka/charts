# Charts

Some helpers to make charts with.

```elm
main : Svg msg
main =
  let
    plane =
      planeFromPoints (data1 ++ data2 ++ data3)
  in
    svg
      [ width (String.fromFloat plane.x.length)
      , height (String.fromFloat plane.x.length)
      ]
      [ linearArea plane [ stroke blueStroke, fill blueFill ] (List.map (clear .x .y) data1)
      , monotone plane [ stroke pinkStroke ] (List.map (dot .x .y (viewCircle transparent)) data2)
      , scatter plane (List.map (dot .x .y (viewCircle "#f9c3b0")) data3)
      , fullHorizontal plane [] 0
      , fullVertical plane [] 0
      , xTicks plane 5 [] 0 [ 1, 2, 3 ]
      , yTicks plane 5 [] 0 [ 1, 2, 3, 5, 6 ]
      , xLabels plane (xLabel "blue" String.fromFloat) 0 [ 1, 2, 3, 5, 10 ]
      , yLabels plane (yLabel "green" String.fromFloat) 0 [ 1, 2, 3, 5, 6 ]
      ]
```

See more examples in the examples folder.