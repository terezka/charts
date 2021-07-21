module Articles.GenderAndSalery exposing (meta, Model, Msg, init, update, view)

import Html as H
import Html.Attributes as HA
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Input as I
import Element.Background as BG
import Ui.Article as Article
import Articles.GenderAndSalery.Bubble as Bubble
import Articles.GenderAndSalery.Bars as Bars
import Articles.GenderAndSalery.Data as Salary


meta =
  { id = "salary-distribution-in-denmark" }


type alias Model =
  { bubbles : Bubble.Model
  , bars : Bars.Model
  , year : Float
  }


init : Model
init  =
  { bubbles = Bubble.init
  , bars = Bars.init
  , year = 2019
  }


type Msg
  = BubbleMsg Bubble.Msg
  | BarsMsg Bars.Msg
  | OnYear Float


update : Msg -> Model -> Model
update msg model =
  case msg of
    BubbleMsg subMsg ->
      { model | bubbles = Bubble.update subMsg model.bubbles }

    BarsMsg subMsg ->
      { model | bars = Bars.update subMsg model.bars }

    OnYear year ->
      { model | year = year
      , bubbles = Bubble.init
      , bars = Bars.reset model.bars
      }


view : Model -> Article.Article Msg
view model =
  { title = "Salary distribution in Denmark"
  , landing = \_ -> E.map BubbleMsg (Bubble.view model.bubbles 2019)
  , body = \_ ->
      [ E.paragraph
          [ F.size 14
          , E.width (E.maximum 600 E.fill)
          ]
          [ E.text "Note that the data visualized here is already aggregated into averages. This means that there might "
          , E.text "be women or men earning more or less than what the numbers show. For example, there may well be a woman CEO being payed the "
          , E.text "same or more than her male counter part, but what the data shows is that "
          , E.el [ F.italic ] (E.text "on average")
          , E.text " this is not the case. This is particularily important to keep in mind when interpreting the second chart."
          ]

      , E.el [ F.size 18 ] (E.text "Womens percentage of mens salary")

      , E.row
          [ E.width E.fill
          , E.spacing 20
          ] <|
          let button year =
                I.button
                  [ E.width E.fill
                  , BG.color (E.rgb255 250 250 250)
                  , B.rounded 5
                  , B.width 1
                  , B.color (if year == model.year then E.rgb255 220 220 220 else E.rgb255 250 250 250)
                  , E.mouseOver [ BG.color (E.rgb255 245 245 245) ]
                  , E.focused [ BG.color (E.rgb255 245 245 245) ]
                  , E.htmlAttribute (HA.style "overflow" "hidden")
                  ]
                  { onPress = Just (OnYear year)
                  , label =
                      let avg =
                            Salary.avgSalaryWomen year / Salary.avgSalaryMen year
                      in
                      E.column
                        [ E.width E.fill
                        , E.spacing 10
                        , E.paddingXY 20 20
                        ]
                        [ E.el [ F.size 14 ] (E.text (String.fromFloat year))
                        , E.text <| "Women earn " ++ String.fromFloat (toFloat (round (avg * 1000)) / 10) ++ " per 100 DKK"
                        ]
                  }
          in
          [ button 2019
          , button 2018
          , button 2017
          , button 2016
          ]

      , E.el
          [ E.paddingEach { top = 0, bottom = 0, left = 0, right = 0 }
          , E.width (E.maximum 1000 E.fill)
          ]
          (E.map BubbleMsg (Bubble.view model.bubbles model.year))

      , E.el [ F.size 18 ] (E.text "Women in each salary bracket")

      , E.el
          [ E.paddingEach { top = 0, bottom = 80, left = 0, right = 0 }
          , E.width (E.maximum 1000 E.fill)
          ]
          (E.map BarsMsg (Bars.view model.bars model.year))

      , E.el [ F.size 14 ] (E.text "Source: Danmarks Statestik.")
      ]
  }