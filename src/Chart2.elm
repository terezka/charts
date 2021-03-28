


type Property data deco
  = Property (PropertyConfig data deco)
  | Stacked (List (PropertyConfig data deco))



type alias PropertyConfig =
  { value : data -> Maybe Float
  , below : List (data -> Maybe Float)
  , attrs : List (Attribute deco)
  , extra : data -> List (Attribute deco)
  }


property : (data -> Maybe Float) -> List (Attribute deco) -> (data -> List (Attribute deco)) -> Property data deco
property value attrs extra =
  Property
    { value = value
    , below = []
    , attrs = attrs
    , extra = extra
    }


stacked : List (Property data deco) -> Property data deco
stacked properties =
  let toConfig prop =
        case prop of
          Property config -> [config]
          Stacked configs -> configs

      stack list prev result =
        case list of
          one :: rest ->
            stack rest (one.value :: prev) ({ one | below = prev } :: result)

          [] ->
            result
  in
  stack (List.concatMap toConfig (List.reverse properties)) [] []
    |> List.reverse



type alias Bars data =
  { round : Optional Float
  , roundBottom : Optional Bool
  , margin : Optional Float
  , spacing : Optional Float
  , name : Optional String
  , start : Maybe (data -> Float)
  , end : Maybe (data -> Float)
  }


bars : List (Attribute (Bars data)) -> List (Property data Bar) -> List data -> Element data
bars edits properties data =
  let config =
        apply edits
          { round = Default 0
          , roundBottom = Default False
          , grouped = Default False
          , margin = Default 0.1
          , spacing = Default 0.01
          , name = Default ""
          , start = Nothing
          , end = Nothing
          }

      bins =
        C.toBins config.start config.end data

      space =
        { between = D.value config.spacing
        , margin = D.value config.margin
        }

      toItems _ =
        if D.value config.grouped then
          C.toBarItems space properties bins
        else
          List.concatMap (\p -> C.toBarItems space [p] bins) properties

      toTicks plane =
        { acc | xs = List.concatMap (\i -> [i.start, i.end]) bins }

      toYs =
        List.map (\prop bin -> prop.visually bin.datum) properties

      toXYBounds =
        makeBounds [.start >> Just, .end >> Just] toYs bins
  in
  BarsElement toXYBounds toItems toTicks <| \_ plane items ->
    -- TODO use cid
    C.bars plane
      { round = D.value config.round
      , roundBottom = D.value config.roundBottom
      , attrs = \i d -> [] -- TODO
      }
      items




type alias Bar =
  { name : Optional String
  , unit : Optional String
  , color : Optional String
  , pattern : Optional Pattern
  }


series : (data -> Float) -> List (Property data Series) -> Element data


type alias Series =
  { name : Optional String
  , unit : Optional String
  , interpolation : Optional Interpolation
  , dot : Optional Dot
  }


type Interpolation
  = Linear (Optional Dashed)
  | Monotone (Optional Dashed)
  | Stepped (Optional Dashed)


type Dot
  = Predefined
      (Optional String)
      (Optional Shape)
      (Optional Border)
      (Optional Fill)
      (Optional Aura)
      (Optional Float)
  | Custom
      (S.Svg Never)

