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
    [ E.el
        [ B.widthEach { top = 0, bottom = 0, left = 1, right = 0 }
        , E.width (E.maximum 1 E.fill)
        , B.color (E.rgb255 200 200 200)
        , E.height E.fill
        , E.moveRight 6
        , E.alignTop
        ]
        E.none

    , E.row
        [ E.rotate (degrees 90)
        , E.width (E.maximum 15 E.fill)
        , E.alignTop
        , E.moveDown 20
        , E.moveLeft 27
        ]
        [ E.el
            [ F.size 14
            , E.paddingXY 10 0
            , F.color (E.rgb255 130 130 130)
            , BG.color (E.rgb255 256 256 256)
            , E.alignLeft
            ]
            (E.text example.title)
        ]

    , E.row
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
