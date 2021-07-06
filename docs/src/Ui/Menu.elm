module Ui.Menu exposing (Group, Link, small, links)


import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG


type alias Group =
  { title : Link
  , links : List Link
  }


type alias Link =
  { url : String
  , title : String
  }


description : E.Element msg
description =
  E.paragraph
    [ F.color (E.rgb255 130 130 130)
    , F.size 12
    , E.width (E.px 300)
    , E.alignTop
    ]
    [ E.text "A SVG chart library for making beautiful charts painlessly. Written in all Elm." ]


small : E.Element msg
small =
  E.row
    [ E.width E.fill
    , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
    ]
    [ E.column
      [ E.alignTop
      , E.spacing 5
      , E.alignLeft
      , E.width (E.px 300)
      ]
      [ E.link []
          { url = "/"
          , label =
              E.row [ F.size 20 ] [ E.text "elm-charts" ]
          }
      ]
    , E.row
        [ E.spacing 40
        , E.alignRight
        , F.size 13
        ]
        links
    ]


links : List (E.Element msg)
links =
  List.map viewLink
    [ Link "/quick-start" "Getting started"
    , Link "/documentation" "Documentation"
    --, Link "/gallery" "Gallery"
    , Link "/administration" "Administration"
    ]


viewGroup : Group -> E.Element msg
viewGroup group =
   E.column
    [ E.alignTop
    , E.spacing 5
    ]
    [ E.el
        [ F.size 16
        , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
        ]
        (viewLink group.title)
    , group.links
        |> List.map viewLink
        |> E.column [ E.spacing 5, F.size 13 ]
    ]



viewLink : Link -> E.Element msg
viewLink link =
  E.link []
    { url = link.url
    , label = E.text link.title
    }

