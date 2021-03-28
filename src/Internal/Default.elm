module Internal.Default exposing (..)


type Constant a
  = Default a
  | Given a


value : Constant a -> a
value v =
  case v of
    Default a -> a
    Given a -> a


use : a -> Constant a -> a
use default v =
  case v of
    Default _ -> default
    Given a -> a


apply : List (a -> a) -> a -> a
apply funcs default =
  let apply_ f a = f a in
  List.foldl apply_ default funcs
