module Ui.Tabs exposing (..)

import Html.Attributes as HA
import Ui.Layout as Layout
import Ui.Menu as Menu
import Ui.Code as Code
import SyntaxHighlight as SH
import Dict
import Element as E
import Element.Font as F
import Element.Input as I
import Element.Border as B
import Element.Background as BG
import Examples


type alias Config a =
  { toUrl : a -> String
  , toTitle : a -> String
  , selected : String
  , all : List a
  }


view : Config a -> E.Element msg
view config =
  E.el
    [ E.width E.fill
    , E.paddingXY 0 30
    , E.scrollbarX
    , E.htmlAttribute (HA.style "min-height" "38px")
    , E.htmlAttribute (HA.style "box-sizing" "content-box")
    ] <|
    E.row
      [ E.width E.fill
      , E.height E.fill
      , E.spacing 10
      , E.paddingXY 10 0
      , B.color (E.rgb255 220 220 220)
      , B.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
      ]
      (List.map (viewOne config) <| List.filter (\a -> config.toTitle a /= "Front page" && config.toTitle a /= "Basic") config.all)


viewOne : Config a -> a -> E.Element msg
viewOne config item =
  E.link
    [ F.size 14
    , E.paddingXY 30 10
    , E.moveDown 1
    , E.paddingEach { top = 10, bottom = if config.selected == config.toUrl item then 11 else 10, left = 30, right = 30 }
    , BG.color (E.rgb255 255 255 255)
    , B.color (E.rgb255 220 220 220)
    , if config.selected == config.toUrl item then F.color (E.rgb255 0 0 0) else F.color (E.rgb255 120 120 120)
    , B.widthEach { top = 1, bottom = if config.selected == config.toUrl item then 0 else 1, left = 1, right = 1 }
    , B.roundEach { topLeft = 5, topRight = 5, bottomLeft = 0, bottomRight = 0 }
    ]
    { url = config.toUrl item
    , label = E.text (config.toTitle item)
    }