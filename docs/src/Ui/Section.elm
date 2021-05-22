module Ui.Section exposing (..)


import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Svg as S exposing (Svg, svg, g, circle, text_, text)
import Svg.Attributes as SA exposing (width, height, stroke, fill, r, transform)
import Svg.Coordinates as Coordinates
import Browser
import Time
import Data.Iris as Iris
import Data.Salary as Salary
import Data.Education as Education
import Dict

import Chart as C
import Chart.Attributes as CA
import Chart.Item as CI
import Chart.Svg as CS

import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG

import SyntaxHighlight as SH


type alias Configuration msg =
  { title : String
  , code : String
  , chart : () -> H.Html msg
  }


view :
  { title : String
  , frame : String
  , onSelect : String -> Int -> msg
  , selected : Dict.Dict String Int
  , configs : List (Configuration msg)
  } -> E.Element msg
view config =
  let selectedId =
          Dict.get config.title config.selected
            |> Maybe.withDefault 0

      selectedConfig =
        List.drop selectedId config.configs
          |> List.head
          |> Maybe.withDefault (Configuration "" "" (\_ -> H.text ""))

      viewSubConfig i c =
        I.button
          [ F.size 14
          , if i == selectedId
              then F.color (E.rgb255 0 0 0)
              else F.color (E.rgb255 80 80 80)
          ]
          { onPress = Just (config.onSelect config.title i)
          , label = E.text <|
              if i == selectedId
              then "·  " ++ c.title
              else "   " ++ c.title
          }
  in
  E.row
    [ E.width E.fill
    , E.paddingEach { top = 10, bottom = 70, left = 0, right = 0 }
    ]
    [ E.column
        [ E.alignTop
        , E.width (E.fillPortion 4)
        ]
        [ E.el
            [ F.size 16
            , F.color (E.rgb255 0 0 0)
            , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
            ]
            (E.text config.title)
        , config.configs
            |> List.indexedMap viewSubConfig
            |> E.column
                [ E.width (E.fillPortion 1)
                , E.spacing 10
                , E.paddingEach { top = 10, bottom = 20, left = 0, right = 0 }
                ]
        , E.el
            [ F.size 16
            , F.color (E.rgb255 0 0 0)
            , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
            ]
            (E.text "Line charts")
        , E.el
            [ F.size 16
            , F.color (E.rgb255 0 0 0)
            , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
            ]
            (E.text "Interactivity")
        ]

    , E.column
        [ E.width (E.fillPortion 9)
        , E.height E.fill
        ]
        [ E.row
            [ F.size 30
            , E.paddingEach { top = 0, bottom = 25, left = 0, right = 0 }
            ]
            [ E.text "Scatter charts"
            , E.el [ F.color (E.rgb255 130 130 130) ] (E.text " · Data dependent styling")
            ]
        , E.paragraph
            [ F.size 14
            , E.paddingEach { top = 0, bottom = 25, left = 0, right = 0 }
            ]
            [ E.text "Style individual data points differently. In the example below, we use "
            , E.text "the property `.x` of each data point to display a different size for each point. For "
            , E.text "another property we use highlight a particuler data point."
            ]
        , E.el
          [ E.width E.fill
          , E.height E.fill
          , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
          ]
          (E.html <| selectedConfig.chart ())
        , E.column
            [ E.width E.fill
            , E.height E.fill
            ]
            [ H.div []
                [ SH.useTheme SH.gitHub
                , config.frame
                    |> String.replace "{{CONFIG}}" (String.trim selectedConfig.code)
                    |> fixIndent
                    |> SH.elm
                    |> Result.map (SH.toBlockHtml (Just 1))
                    |> Result.withDefault (H.pre [] [ H.code [] [ H.text config.frame ]])
                ]
                |> E.html
                |> E.el
                    [ E.width E.fill
                    , E.height (E.fill |> E.minimum 300)
                    --, BG.color (E.rgb255 245 245 245)
                    --, B.rounded 3
                    --, B.width 1
                    --, E.paddingXY 15 0
                    , E.htmlAttribute (HA.style "white-space" "pre")
                    , F.size 14
                    , F.family [ F.typeface "Source Code Pro", F.monospace ]
                    , E.alignTop
                    , E.scrollbarX
                    ]
              ]
          ]
    ]


fixIndent : String -> String
fixIndent code =
  code
    |> String.lines
    |> List.drop 1
    |> List.map (\x ->
        let trimmed = String.trimLeft x
            indent = String.length x - String.length trimmed
        in
        ( indent, x ))
    |> (\xs ->
        let smallest = Maybe.withDefault 0 <| List.minimum (List.map Tuple.first xs) in
        List.map (\( _, x ) -> String.dropLeft smallest x) xs
          |> String.join "\n"
      )


