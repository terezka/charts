module Ui.Menu exposing (Group, Link, small, expanded)


import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG


type alias Group =
  { title : String
  , links : List Link
  }


type alias Link =
  { url : String
  , title : String
  }


expanded : E.Element msg
expanded =
  E.row
      [ E.width E.fill
      , E.spacing 80
      ]
      [ E.column
        [ E.alignTop
        , E.spacing 5
        , E.width (E.px 300)
        ]
        [ E.row
            [ F.size 20
            ]
            [ E.text "terezka/elm-charts"
            , E.el [ F.color (E.rgb255 130 130 130) ] (E.text "-alpha")
            ]
        , E.paragraph
            [ E.paddingEach { top = 10, bottom = 0, left = 0, right = 0 }
            , F.color (E.rgb255 130 130 130)
            , F.size 12
            ]
            [ E.text "Alpha version. Feel free to use, but please do not share publicly yet. Documentation is unfinished/wrong and API liable to breaking changes." ]
        ]
      , E.row
          [ E.spaceEvenly
          , E.width E.fill
          , E.alignRight
          ] <| List.map viewGroup
          [ { title = "Documentation"
            , links =
                [ Link "/quick-start" "Quick start"
                , Link "/documentation#scatter-charts" "Scatter charts"
                , Link "/documentation#line-charts" "Line charts"
                , Link "/documentation#bar-charts" "Bar charts"
                , Link "/documentation#interactivity" "Interactivity"
                , Link "/documentation#custom-axes" "Custom axes"
                , Link "/documentation#custom-labels" "Custom labels"
                ]
            }
          , { title = "Real data examples"
            , links =
                [ Link "/real#salery-distribution" "Salary distribution in Denmark"
                , Link "/real#perceptions-of-probability" "Perceptions of Probability"
                , Link "/real#community-examples" "Community examples"
                ]
            }
          , { title = "Administration"
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


small : E.Element msg
small =
  E.row
    [ E.width E.fill
    , E.paddingEach { top = 0, bottom = 30, left = 0, right = 0 }
    , B.color (E.rgb255 230 230 230)
    , B.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
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
              E.row
                [ F.size 20 ]
                [ E.text "elm-charts"
                , E.el [ F.color (E.rgb255 130 130 130) ] (E.text "-alpha")
                ]
          }
      , E.paragraph
            [ E.paddingEach { top = 10, bottom = 0, left = 0, right = 0 }
            , F.color (E.rgb255 130 130 130)
            , F.size 12
            ]
            [ E.text "Alpha version. Feel free to use, but please do not share publicly yet. Documentation is unfinished/wrong and API liable to breaking changes." ]
      ]
    , E.column
        [ E.spacing 5
        , E.alignRight
        , F.size 13
        ] <| List.map viewLink
        [ Link "/quick-start" "Quick start"
        , Link "/documentation" "Documentation"
        , Link "/real" "Real data examples"
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
        (E.text group.title)
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

