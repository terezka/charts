module Pages.QuickStart exposing (view)

import View exposing (View)
import Charts.Basics exposing (Example)
import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Ui.Layout as Layout
import Ui.CompactExample as CompactExample
import Ui.Code as Code


view : View msg
view =
  { title = "elm-charts | Quick start"
  , body =
      Layout.view
        [ E.row
            [ F.size 16
            , E.paddingEach { top = 0, bottom = 15, left = 0, right = 0 }
            ]
            [ E.text "← terezka/elm-charts"
            , E.el [ F.color (E.rgb255 130 130 130) ] (E.text "-alpha")
            ]

        , E.el
            [ F.size 50
            , E.paddingEach { top = 0, bottom = 90, left = 0, right = 0 }
            ]
            (E.text "Quick start")

        , E.column
            [ E.width E.fill
            , E.height E.fill
            , E.spacing 90
            , E.paddingEach { top = 0, bottom = 50, left = 0, right = 0 }
            ]
            <| List.map CompactExample.view
                [ Charts.Basics.empty
                , Charts.Basics.scatter
                , Charts.Basics.lines
                , Charts.Basics.areas
                , Charts.Basics.bars
                ]
        ]
  }

