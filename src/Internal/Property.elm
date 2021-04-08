module Internal.Property exposing (..)


{-| -}
type Property data deco
  = Property (Config data deco)
  | Stacked (List (Config data deco))


{-| -}
type alias Config data deco =
  { value : data -> Maybe Float
  , visual : data -> Maybe Float
  , name : String
  , unit : String
  , attrs : List (deco -> deco)
  , extra : data -> List (deco -> deco) -- TODO
  }


{-| -}
property : (data -> Maybe Float) -> String -> String -> List (deco -> deco) -> (data -> List (deco -> deco)) -> Property data deco
property value name unit attrs extra =
  Property
    { value = value
    , visual = value
    , name = name
    , unit = unit
    , attrs = attrs
    , extra = extra
    }


{-| -}
stacked : List (Property data deco) -> Property data deco
stacked properties =
  let configs =
        List.concatMap toConfigs (List.reverse properties)

      stack list prev result =
        case list of
          one :: rest ->
            let toYs_ = one.value :: prev in
            stack rest toYs_ ({ one | visual = toVisual toYs_ } :: result)

          [] ->
            result

      toVisual toYs_ datum =
        let vs = List.filterMap (\toY -> toY datum) toYs_ in
        if List.length vs /= List.length toYs_ then Nothing else Just (List.sum vs)
  in
  Stacked (stack configs [] [])


{-| -}
toYs : List (Property data deco) -> List (data -> Maybe Float)
toYs properties =
  let each prop =
        case prop of
          Property config -> [ config.visual ]
          Stacked configs -> List.map .visual configs
  in
  List.concatMap each properties


{-| -}
toConfigs : Property data deco -> List (Config data deco)
toConfigs prop =
  case prop of
    Property config -> [ config ]
    Stacked configs -> configs
