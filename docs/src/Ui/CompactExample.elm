module Ui.CompactExample exposing (view)

import Charts.Basics exposing (Example)
import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Ui.Layout as Layout
import Ui.Code as Code


view : Example msg -> E.Element msg
view example =
  E.row
    [ E.width E.fill
    , E.spacing 25
    ]
    [ E.row
        [ E.width E.fill
        , E.spacing 50
        ]
        [ E.el
            [ E.width (E.fillPortion 2)
            , E.alignTop
            , F.size 10
            ] <| E.html <| example.chart ()
        , E.el
            [ E.width (E.fillPortion 6)
            , E.alignTop
            , F.size 12
            , BG.color (E.rgb255 250 250 250)
            ]
            (Code.view { template = example.code, edits = [] })
        ]
    ]
