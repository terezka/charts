module Internal.Property exposing (..)


{-| -}
type Property data meta inter deco
  = Property (Config data meta inter deco)
  | Stacked (List (Config data meta inter deco))


{-| -}
type alias Config data meta inter deco =
  { value : data -> Maybe Float
  , visual : data -> Maybe Float
  , meta : meta
  , inter : List (inter -> inter)
  , attrs : List (deco -> deco)
  , extra : data -> List (deco -> deco)
  }


{-| -}
property : (data -> Maybe Float) -> meta -> List (inter -> inter) -> List (deco -> deco) -> Property data meta inter deco
property value meta inter attrs =
  Property
    { value = value
    , visual = value
    , meta = meta
    , inter = inter
    , attrs = attrs
    , extra = always []
    }


{-| -}
variation : (data -> List (deco -> deco)) -> Property data meta inter deco -> Property data meta inter deco
variation attrs prop =
  case prop of
    Property c ->  Property { c | extra = attrs }
    Stacked cs -> Stacked (List.map (\c -> { c | extra = attrs }) cs)


{-| -}
stacked : List (Property data meta inter deco) -> Property data meta inter deco
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
toYs : List (Property data meta inter deco) -> List (data -> Maybe Float)
toYs properties =
  let each prop =
        case prop of
          Property config -> [ config.visual ]
          Stacked configs -> List.map .visual configs
  in
  List.concatMap each properties


{-| -}
toConfigs : Property data meta inter deco -> List (Config data meta inter deco)
toConfigs prop =
  case prop of
    Property config -> [ config ]
    Stacked configs -> configs
