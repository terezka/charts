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
  toDefault pink [ pink, purple, mint, blue, red, orange, turquoise, green, darkYellow, darkBlue, magenta, brown, yellow ]


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
pink : String
pink =
  "#f56dbc"


{-| -}
purple : String
purple =
  "#7c29ed"


{-| -}
blue : String
blue =
  "#1976d2"


green : String
green =
  "#109618"


{-| -}
orange : String
orange =
  "#e47d32"


{-| -}
turquoise : String
turquoise =
  "#4eaea7"


{-| -}
red : String
red =
  "#d32f2f"


{-| -}
darkYellow : String
darkYellow =
  "#aaaa11"


{-| -}
darkBlue : String
darkBlue =
  "#135ca5"


{-| -}
magenta : String
magenta =
  "#de23a5"


{-| -}
brown : String
brown =
  "#7e413b"


{-| -}
mint : String
mint =
  "#70d8cb"


{-| -}
yellow : String
yellow =
  "#e1e10e"


gray : String
gray =
  "#EFF2FA"


darkGray : String
darkGray =
  "rgb(200 200 200)"

