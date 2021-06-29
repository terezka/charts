module Ui.Menu exposing (Group, Link, small, expanded)


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


expanded : E.Element msg
expanded =
  E.column
      [ E.width E.fill
      , E.spacing 20
      ]
      [ E.column
        [ E.alignTop
        , E.spacing 5
        ]
        [ E.row
            [ F.size 40 ]
            [ E.text "elm-charts" ]
        ]
      , E.row
          [ E.spacing 100
          , E.width E.fill
          ]
          [ description
          , E.row
              [ E.spaceEvenly
              , E.width E.fill
              , E.alignRight
              ] <| List.map viewGroup
              [ { title = Link "/documentation" "Documentation"
                , links =
                    [ Link "/quick-start" "Quick start"
                    , Link "/documentation/scatter-charts" "Scatter charts"
                    , Link "/documentation/line-charts" "Line charts"
                    , Link "/documentation/bar-charts" "Bar charts"
                    , Link "/documentation/navigation" "Navigation"
                    , Link "/documentation/interactivity" "Interactivity"
                    ]
                }
              , { title = Link "/real" "Gallery"
                , links =
                    [ Link "/real#salary-distribution" "Salary distribution in Denmark"
                    , Link "/real#perceptions-of-probability" "Perceptions of Probability"
                    , Link "/real#community-examples" "Community examples"
                    ]
                }
              , { title = Link "/administration" "Administration"
                , links =
                    [ Link "/roadmap" "Roadmap"
                    , Link "/donating" "Donating"
                    , Link "/consulting" "Consulting"
                    , Link "https://github.com/terezka/charts" "Github"
                    , Link "https://twitter.com/tereza_sokol" "Twitter"
                    ]
                }
              ]
          ]
      ]


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
        ] <| List.map viewLink
        [ Link "/quick-start" "Quick start"
        , Link "/documentation" "Documentation"
        , Link "/real" "Gallery"
        , Link "/administration" "Administration"
        ]
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

