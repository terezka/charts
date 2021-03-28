module Internal.Property exposing (..)



type Property data deco
  = Property (Config data deco)
  | Stacked (List (Config data deco))



type alias Config data deco =
  { value : data -> Maybe Float
  , visual : data -> Maybe Float
  , attrs : List (deco -> deco)
  , extra : data -> List (deco -> deco) -- TODO
  }


property : (data -> Maybe Float) -> List (deco -> deco) -> (data -> List (deco -> deco)) -> Property data deco
property value attrs extra =
  Property
    { value = value
    , visual = value
    , attrs = attrs
    , extra = extra
    }


stacked : List (Property data deco) -> Property data deco
stacked properties =
  let configs =
        List.concatMap toConfigs (List.reverse properties)

      stack list prev result =
        case list of
          one :: rest ->
            stack rest (one.value :: prev) ({ one | visual = toVisual (one.value :: prev) } :: result)

          [] ->
            result

      toVisual prev datum =
        case List.filterMap (\toY -> toY datum) prev of
          [] -> Nothing
          ys -> Just (List.sum ys)
  in
  Stacked (stack configs [] [])


toYs : List (Property data deco) -> List (data -> Maybe Float)
toYs properties =
  let each prop =
        case prop of
          Property config -> [config.visual]
          Stacked configs -> List.map .visual configs
  in
  List.concatMap each properties


toConfigs : Property data deco -> List (Config data deco)
toConfigs prop =
  case prop of
    Property config -> [config]
    Stacked configs -> configs
