module Ui.Layout exposing (view)


import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG


view : List (E.Element msg) -> List (H.Html msg)
view children =
  List.singleton <|
    E.layout
      [ E.width E.fill
      , F.family [ F.typeface "IBM Plex Sans", F.sansSerif ]
      ] <|
      E.column
        [ E.width (E.maximum 1000 E.fill)
        , E.paddingEach { top = 30, bottom = 20, left = 0, right = 0 }
        , E.centerX
        , F.size 12
        , F.color (E.rgb255 80 80 80)
        ]
        children