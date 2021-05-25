module Ui.Section exposing (Section, Model, init, view)


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
import Ui.Code as Code

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



type alias Model =
  { selected : String
  , selectedSub : String
  }


init : Section msg -> Model
init section =
  { selected = section.title
  , selectedSub = (Tuple.first section.configs).title
  }


type alias Section msg =
  { title : String
  , template : String
  , configs : ( Config msg, List (Config msg) )
  }


type alias Config msg =
  { title : String
  , edits : List String
  , chart : () -> H.Html msg
  }


allConfigs : Section msg -> List (Config msg)
allConfigs section =
  section.configs |> \(x, xs) -> x :: xs



-- VIEW


view : (String -> String -> msg) -> Model -> List (Section msg) -> E.Element msg
view onSelect model sections =
  let selectedSection =
        List.filter (\s -> s.title == model.selected) sections
          |> List.head
          |> Maybe.withDefault (Section "" "" ( Config "" [] (\_ -> H.text ""), [] ))

      selectedConfig =
        List.filter (\s -> s.title == model.selectedSub) (allConfigs selectedSection)
          |> List.head
          |> Maybe.withDefault (Tuple.first selectedSection.configs)
  in
  E.row
    [ E.width E.fill
    , E.paddingEach { top = 60, bottom = 70, left = 0, right = 0 }
    ]
    [ sidebar onSelect model sections
    , content selectedSection selectedConfig
    ]


sidebar : (String -> String -> msg) -> Model -> List (Section msg) -> E.Element msg
sidebar onSelect model sections =
  let viewTitle section =
        if model.selected == section.title
        then viewOpen section
        else viewClosed section

      viewClosed section =
        I.button
          [ F.size 16
          , F.color (E.rgb255 80 80 80)
          ]
          { onPress = Just <| onSelect section.title (Tuple.first section.configs).title
          , label = E.text section.title
          }

      viewOpen section =
        E.column
          []
          [ E.el
              [ F.size 16
              , F.color (E.rgb255 0 0 0)
              , E.paddingEach { top = 0, bottom = 10, left = 0, right = 0 }
              ]
              (E.text section.title)
          , E.column
              [ E.width (E.fillPortion 1)
              , E.paddingEach { top = 0, bottom = 0, left = 5, right = 0 }
              ]
              (List.map (viewSub section) (allConfigs section))
          ]

      viewSub section config =
        let isSelected =
              config.title == model.selectedSub
        in
        I.button
          [ F.size 14
          , E.paddingEach { top = 5, bottom = 5, left = 10, right = 0 }
          , if isSelected
              then F.color (E.rgb255 0 0 0)
              else F.color (E.rgb255 80 80 80)
          , B.widthEach { top = 0, bottom = 0, left = 1, right = 0 }
          , if isSelected
              then B.color (E.rgb255 180 180 180)
              else B.color (E.rgb255 230 230 230)
          , E.moveLeft 2
          ]
          { onPress = Just (onSelect section.title config.title)
          , label = E.text config.title
          }
  in
  E.column
    [ E.alignTop
    , E.width (E.fillPortion 4)
    , E.spacing 20
    ]
    [ E.el [ F.size 14 ] (E.text "Documentation")
    , E.column
      [ E.spacing 15
      ]
      (List.map viewTitle sections)
    ]


content : Section msg -> Config msg -> E.Element msg
content section config =
  E.column
    [ E.width (E.fillPortion 9)
    , E.height E.fill
    ]
    [ E.row
        [ F.size 28
        , E.paddingEach { top = 0, bottom = 25, left = 0, right = 0 }
        ]
        [ E.text section.title
        , E.el [ F.color (E.rgb255 130 130 130) ] (E.text <| " · " ++ config.title)
        ]
    , E.el
      [ E.width E.fill
      , E.height E.fill
      , E.paddingEach { top = 0, bottom = 40, left = 0, right = 0 }
      ]
      (E.html <| config.chart ())
    , E.column
        [ E.width E.fill
        , E.height E.fill
        , BG.color (E.rgb255 250 250 250)
        ]
        [ Code.view { template = section.template, edits = config.edits } ]
      ]

