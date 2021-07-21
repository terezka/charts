module Articles.GenderAndSalery exposing (meta, Model, Msg, init, update, view)

import Html as H
import Element as E
import Element.Font as F
import Element.Border as B
import Element.Background as BG
import Ui.Article as Article
import Articles.GenderAndSalery.Bubble as Bubble
import Articles.GenderAndSalery.Bars as Bars


meta =
  { id = "salery-distribution-in-denmark" }


type alias Model =
  { bubbles : Bubble.Model
  , bars : Bars.Model
  }


init : Model
init  =
  { bubbles = Bubble.init
  , bars = Bars.init
  }


type Msg
  = BubbleMsg Bubble.Msg
  | BarsMsg Bars.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    BubbleMsg subMsg ->
      { model | bubbles = Bubble.update subMsg model.bubbles }

    BarsMsg subMsg ->
      { model | bars = Bars.update subMsg model.bars }


view : Model -> Article.Article Msg
view model =
  { title = "Salary distribution in Denmark"
  , landing = E.html <| H.map BubbleMsg (Bubble.view model.bubbles)
  , body =
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

      , E.el
          [ E.paddingEach { top = 50, bottom = 40, left = 0, right = 0 }
          , E.width (E.maximum 1000 E.fill)
          ]
          (E.html <| H.map BubbleMsg (Bubble.view model.bubbles))

      , E.el
          [ E.paddingEach { top = 0, bottom = 80, left = 0, right = 0 }
          , E.width (E.maximum 1000 E.fill)
          ]
          (E.map BarsMsg (Bars.view model.bars))
      ]
  }