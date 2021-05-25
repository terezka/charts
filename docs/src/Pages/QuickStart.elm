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
import Ui.Menu as Menu


view : View msg
view =
  { title = "elm-charts | Quick start"
  , body =
      Layout.view
        [ Menu.small
        , E.el
            [ F.size 30
            , E.paddingEach { top = 60, bottom = 40, left = 0, right = 0 }
            ]
            (E.text "Quick start")

        , E.column
            [ E.width E.fill
            , E.height E.fill
            , E.spacing 50
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

