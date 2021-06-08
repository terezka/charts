module Internal.Helpers exposing (..)


import Dict exposing (Dict)


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs


withSurround : List a -> (Int -> Maybe a -> a -> Maybe a -> b) -> List b
withSurround all func =
  let fold index prev acc list =
        case list of
          a :: b :: rest -> fold (index + 1) (Just a) (acc ++ [ func index prev a (Just b) ]) (b :: rest)
          a :: [] -> acc ++ [ func index prev a Nothing ]
          [] -> acc
  in
  fold 0 Nothing [] all


gatherWith : (a -> a -> Bool) -> List a -> List ( a, List a )
gatherWith testFn list =
    let helper scattered gathered =
          case scattered of
            [] -> List.reverse gathered
            toGather :: population ->
              let ( gathering, remaining ) = List.partition (testFn toGather) population in
              helper remaining <| ( toGather, gathering ) :: gathered
    in
    helper list []



-- DEFAULTS


toDefaultColor : Int -> String
toDefaultColor =
  toDefault blue [ pink, purple, blue, turquoise, orange, green, red ]


toDefault : a -> List a -> Int -> a
toDefault default items index =
  let dict = Dict.fromList (List.indexedMap Tuple.pair items)
      numOfItems = Dict.size dict
      itemIndex = remainderBy numOfItems index
  in
  Dict.get itemIndex dict
    |> Maybe.withDefault default



-- COLORS


{-| -}
blue : String
blue =
  "#1976d2"


{-| -}
orange : String
orange =
  "#e47d32"


{-| -}
pink : String
pink =
  "#f56dbc"


purple : String
purple =
  "#7c29ed"


{-| -}
green : String
green =
  "#388e3c"


{-| -}
red : String
red =
  "#d32f2f"


{-| -}
turquoise : String
turquoise =
  "#4eaea7"