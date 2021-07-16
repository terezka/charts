module Ui.Layout exposing (view, link)


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
        [ E.width (E.maximum 1060 E.fill)
        , E.paddingEach { top = 30, bottom = 20, left = 30, right = 30 }
        , E.centerX
        , F.size 12
        , F.color (E.rgb255 80 80 80)
        ]
        (children ++ [copyright])


copyright : E.Element msg
copyright =
  E.el
    [ F.size 12
    , F.color (E.rgb255 180 180 180)
    , E.paddingEach { top = 30, bottom = 20, left = 0, right = 0 }
    , E.alignRight
    ]
    (E.text "Designed and developed by Tereza Sokol © 2021")


link : String -> String -> E.Element msg
link url label =
  E.link
    [ F.underline ]
    { url = url
    , label = E.text label
    }