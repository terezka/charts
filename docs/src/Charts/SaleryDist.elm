module Charts.SaleryDist exposing (Model, Msg, init, update, view)

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
import Element.Background as BG


type alias Model =
  { selection : Maybe { a : Coordinates.Point, b : Coordinates.Point }
  , hovering : List (CI.Product CI.General Salary.Datum)
  , window : Maybe Coordinates.Position
  , year : Float
  }


init : Model
init =
  { selection = Nothing
  , hovering = []
  , window = Nothing
  , year = 2019
  }


type Msg
  = OnHover (List (CI.Product CI.General Salary.Datum)) Coordinates.Point
  | OnMouseDown Coordinates.Point
  | OnMouseUp Coordinates.Point
  | OnReset
  | OnExitWindow
  | OnYear Float


update : Msg -> Model -> Model
update msg model =
  case msg of
    OnHover hovering coords ->
      case model.selection of
        Nothing -> { model | hovering = hovering }
        Just select -> { model | selection = Just { select | b = coords }, hovering = [] }

    OnMouseDown coords ->
      { model | selection = Just { a = coords, b = coords } }

    OnMouseUp coords ->
      case model.selection of
        Nothing -> model
        Just select ->
          if select.a == coords
          then { model | selection = Nothing, window = Nothing }
          else
            { model | selection = Nothing
            , window = Just
                { x1 = min select.a.x coords.x
                , x2 = max select.a.x coords.x
                , y1 = min select.a.y coords.y
                , y2 = max select.a.y coords.y
                }
            }

    OnReset ->
      { model | hovering = [] }

    OnExitWindow ->
      { model | window = Nothing }

    OnYear year ->
      { model | year = year }


view : Model -> H.Html Msg
view model =
  C.chart
    [ CA.height 530
    , CA.width 1000
    , CA.static
    , CA.marginLeft 0
    , CA.marginRight 0
    , CA.paddingTop 15

    , CA.range <|
        case model.window of
          Just window -> [ C.lowest window.x1 C.exactly, C.highest window.x2 C.exactly ]
          Nothing -> [ C.lowest 20000 C.orHigher ]

    , CA.domain <|
        case model.window of
          Just window -> [ C.lowest window.y1 C.exactly, C.highest window.y2 C.exactly ]
          Nothing -> [ C.lowest 76 C.orHigher ]

    , CA.events
        [ C.map2 OnHover (C.getNearest CI.getCenter identity) C.getCoords
            |> C.event "mousemove"

        , C.event "mouseleave" (C.map (\_ -> OnReset) C.getCoords)
        , C.event "mousedown" (C.map OnMouseDown C.getCoords)
        , C.event "mouseup" (C.map OnMouseUp C.getCoords)
        ]

    , CA.htmlAttrs
        [ HA.style "cursor" "crosshair" ]
    ]
    [ C.grid []

    , C.produce 10 CS.ints .x <| \p t ->
        [ C.xLabel [ CA.alignLeft, CA.yOff -20, CA.xOff 3, CA.x (toFloat t) ] [ S.text (String.fromInt t) ] ]

    , C.produce 8 CS.ints .y <| \p t ->
        [ if t == 100 then
            C.title [ CA.alignLeft, CA.yOff -7, CA.xOff 1 ] [ S.text (String.fromInt t) ] { x = p.x.min, y = toFloat t }
          else
            C.yLabel [ CA.alignLeft, CA.yOff -10, CA.xOff 10, CA.y (toFloat t) ] [ S.text (String.fromInt t) ]
      ]

    , C.withPlane <| \p ->
        [ C.title [ CA.fontSize 14, CA.yOff -3 ] [ S.text ("Salary distribution in Denmark " ++ String.fromFloat model.year) ] { x = C.middle p.x, y = p.y.max }
        , C.title [ CA.fontSize 11, CA.yOff 12 ] [ S.text "Data from Danmarks Statestik" ] { x = C.middle p.x, y = p.y.max }
        , C.title [ CA.fontSize 12, CA.yOff 25 ] [ S.text "Average salary in DKK" ] { x = C.middle p.x, y = p.y.min }
        , C.title [ CA.fontSize 12, CA.xOff -15, CA.rotate 90 ] [ S.text "Womens percentage of mens salary" ] { x = p.x.min, y = C.middle p.y }
        , C.line [ CA.dashed [ 4, 2 ], CA.opacity 0.7, CA.color "#f56dbc", CA.x1 Salary.avgSalaryWomen ]
        , C.line [ CA.dashed [ 4, 2 ], CA.opacity 0.7, CA.color "#58a9f6", CA.x1 Salary.avgSalaryMen ]
        ]

    , C.line [ CA.dashed [ 3, 3 ], CA.y1 100 ]

    , salarySeries model 0.7 5 200

    , C.eachProduct <| \p product ->
        let datum = CI.getDatum product
            color = CI.getColor product
            top = CI.getTop p product
            toSvgX = Coordinates.scaleCartesianX p
            toSvgY = Coordinates.scaleCartesianY p
        in
        if String.startsWith "251 " datum.sector then
          [ C.line [ CA.color color, CA.break, CA.x1 top.x, CA.x2 (top.x + toSvgX 10), CA.y1 top.y, CA.y2 (top.y + toSvgY 10) ]
          , C.title [ CA.color color,CA.alignLeft, CA.xOff 5, CA.yOff 3 ] [ S.text "Software engineering" ] { x = top.x + toSvgX 10, y = top.y + toSvgY 10 }
          ]
        else
          []

    , case model.window of
        Just _ ->
         C.htmlAt .max .min -10 10
            [ HA.style "transform" "translate(-100%, -100%)"
            , HA.style "background" "white"
            , HA.style "border" "1px solid rgb(210, 210, 210)"
            ]
            [ viewSalaryDiscrepancyMini model
            , H.button
                [ HA.style "position" "absolute"
                , HA.style "top" "0"
                , HA.style "right" "0"
                , HA.style "background" "transparent"
                , HA.style "color" "rgb(100, 100, 100)"
                , HA.style "border" "0"
                , HA.style "height" "30px"
                , HA.style "width" "30px"
                , HA.style "padding" "0"
                , HA.style "margin" "0"
                , HA.style "cursor" "pointer"
                , HE.onClick OnExitWindow
                ]
                [ H.span
                    [ HA.style "font-size" "28px"
                    , HA.style "position" "absolute"
                    , HA.style "top" "40%"
                    , HA.style "left" "50%"
                    , HA.style "transform" "translate(-50%, -50%)"
                    , HA.style "line-height" "10px"
                    ]
                    [ H.text "⨯" ]
                ]
            ]

        Nothing ->
          C.none

    , C.each model.hovering <| \p item ->
        [ C.tooltip item [] [] [ tooltipContent item ] ]

    , case model.selection of
        Just select -> C.rect [ CA.opacity 0.5, CA.x1 select.a.x, CA.x2 select.b.x, CA.y1 select.a.y, CA.y2 select.b.y ]
        Nothing -> C.none

    , C.svg <| \_ ->
        S.defs []
          [ S.linearGradient
              [ SA.id "colorscale", SA.x1 "0", SA.x2 "100%", SA.y1 "0", SA.y2 "0" ]
              [ S.stop [ SA.offset "0%", SA.stopColor "#f56dbc" ] [] -- most pink
              , S.stop [ SA.offset "30%", SA.stopColor "#de74d7" ] [] -- pink
              , S.stop [ SA.offset "50%", SA.stopColor "#c579f2" ] [] -- middle
              , S.stop [ SA.offset "70%", SA.stopColor "#8a91f7" ] [] -- blue
              , S.stop [ SA.offset "100%", SA.stopColor "#58a9f6" ] [] -- most blue
              ]
          ]

    , C.withPlane <| \p ->
        let toSvgX = Coordinates.scaleCartesianX p
            toSvgY = Coordinates.scaleCartesianY p
            x1 = p.x.max - toSvgX 150
            x2 = p.x.max - toSvgX 20
            y1 = p.y.max - toSvgY 13
            y2 = p.y.max - toSvgY 10
        in
        [ C.rect [ CA.borderWidth 0, CA.x1 x1, CA.x2 x2, CA.y1 y1, CA.y2 y2, CA.color "url(#colorscale)" ]
        , C.title [ CA.fontSize 10 ] [ S.text "more women" ] { x = x1, y = p.y.max - toSvgY 25 }
        , C.title [ CA.fontSize 10 ] [ S.text "more men" ] { x = x2, y = p.y.max - toSvgY 25 }
        , C.htmlAt .max .max -45 -45
            [ HA.style "color" "rgb(90 90 90)"
            , HA.style "cursor" "pointer"
            ]
            [ H.div [ HE.onClick (OnYear 2016) ] [ H.text "2016" ]
            , H.div [ HE.onClick (OnYear 2017) ] [ H.text "2017" ]
            , H.div [ HE.onClick (OnYear 2018) ] [ H.text "2018" ]
            , H.div [ HE.onClick (OnYear 2019) ] [ H.text "2019" ]
            ]
        ]
    ]


viewSalaryDiscrepancyMini : Model -> H.Html Msg
viewSalaryDiscrepancyMini model =
  C.chart
    [ CA.height 100
    , CA.width 167
    , CA.static
    , CA.marginLeft 0
    , CA.marginBottom 0
    , CA.marginTop 0
    , CA.marginRight 0
    , CA.paddingTop 15
    , CA.range [ C.lowest 20000 C.orHigher ]
    , CA.domain [ C.lowest 76 C.orHigher ]
    ]
    [ C.produce 10 CS.ints .x <| \p t ->
        [ C.xLabel [ CA.alignLeft, CA.yOff 15, CA.x (toFloat t) ] [ S.text "" ] ]

    , C.produce 8 CS.ints .y <| \p t ->
        [ C.yLabel [ CA.alignLeft, CA.yOff -5, CA.y (toFloat t) ] [ S.text "" ] ]

    , C.line [ CA.dashed [ 3, 3 ], CA.y1 100, CA.width 0.5 ]

     , case model.window of
        Just select -> C.rect [ CA.borderWidth 0, CA.x1 select.x1, CA.x2 select.x2, CA.y1 select.y1, CA.y2 select.y2 ]
        Nothing -> C.none

    , salarySeries model 0.5 3 4000
    ]


salarySeries : Model -> Float -> Float -> Float -> C.Element Salary.Datum Msg
salarySeries model border auraSize size =
  C.series .salaryBoth
      [ C.property Salary.womenSalaryPerc []
          [ CA.opacity 0.5, CA.circle, CA.border CA.blue, CA.borderWidth border ]
          |> C.variation (\d ->
                let precentOfWomen = Salary.womenPerc d
                    isHovered = List.any (CI.getDatum >> (==) d) model.hovering

                    color =
                      if precentOfWomen < 20
                      then [ CA.border "#58a9f6", CA.color "#58a9f6" ]
                      else if precentOfWomen < 40
                      then [ CA.border "#8a91f7", CA.color "#8a91f7" ]
                      else if precentOfWomen < 60
                      then [ CA.border "#c579f2", CA.color "#c579f2" ]
                      else if precentOfWomen < 80
                      then [ CA.border "#de74d7", CA.color "#de74d7" ]
                      else [ CA.border "#f56dbc", CA.color "#f56dbc" ]

                    aura =
                      if isHovered
                      then [ CA.aura 0.4, CA.auraWidth auraSize, CA.opacity 0.7 ]
                      else []
                in
                [ CA.size (d.numOfBoth / size) ] ++ color ++ aura
              )
      ]
      (List.filter (.year >> (==) model.year) Salary.data)


tooltipContent : CI.Product CI.General Salary.Datum -> H.Html msg
tooltipContent hovered =
  let datum = CI.getDatum hovered
      precentOfWomen = round (Salary.womenPerc datum)
      percentOfSalary = round (Maybe.withDefault 0 (Salary.womenSalaryPerc datum))
      percentOfSalaryMen = round (Maybe.withDefault 0 (Salary.menSalaryPerc datum))
  in
  H.div []
    [ H.h4
        [ HA.style "width" "240px"
        , HA.style "margin-top" "5px"
        , HA.style "margin-bottom" "5px"
        , HA.style "line-break" "normal"
        , HA.style "white-space" "normal"
        , HA.style "line-height" "1.25"
        , HA.style "color" (CI.getColor hovered)
        ]
        [ H.text datum.sector ]

    , H.table
        [ HA.style "color" "rgb(90, 90, 90)"
        , HA.style "width" "100%"
        , HA.style "font-size" "11px"
        ]
        [ H.tr []
            [ H.th [] []
            , H.th [ HA.style "text-align" "right" ] [ H.text "Women" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text "%" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text "Men" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text "%" ]
            ]
        , H.tr []
            [ H.th [ HA.style "text-align" "left" ] [ H.text "Salary" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt (round datum.salaryWomen)) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt percentOfSalary) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt (round datum.salaryMen)) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt percentOfSalaryMen) ]
            ]
        , H.tr []
            [ H.th [ HA.style "text-align" "left" ] [ H.text "Distribution" ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.numOfWomen) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt precentOfWomen) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromFloat datum.numOfMen) ]
            , H.th [ HA.style "text-align" "right" ] [ H.text (String.fromInt (100 - precentOfWomen)) ]
            ]
        ]
    ]
