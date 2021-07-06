module Route exposing (..)

import Url exposing (Url)
import Url.Parser as P


type Route
  = Home
  | QuickStart
  | Documentation
  | Section String
  | Example String String


toRoute : Url -> Maybe Route
toRoute =
  let parser =
        P.oneOf
          [ P.map Home           P.top
          , P.map QuickStart    (P.s "quick-start")
          , P.map Documentation (P.s "documentation")
          , P.map Section       (P.s "documentation" </> P.string)
          , P.map Example       (P.s "documentation" </> P.string </> P.string)
          ]
  in
  Url.parse parser
