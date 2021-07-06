module Session exposing
  ( Session
  , init
  )

import Browser exposing (Document)
import Browser.Navigation as Navigation
import Json.Decode as D


-- MODEL


type alias Session =
  ()


init : D.Value -> Session
init flags =
  ()
