module D1 (main) where

import Mouse
import Graphics.Element exposing (..)
import Text exposing (height, fromString, monospace)

-- toString : a -> String
-- height : Float -> Text -> Text
show' : Float -> a -> Element
show' sz = centered << monospace << Text.height sz << fromString << toString

view e =
  Signal.map (container 800 300 middle << flow down) <|           -- <| === $ in Haskell
    Signal.map2 (\a b -> [a,b])
      e
      (Signal.constant <| (show' 30) "Signal.map show Mouse.position")

-- map : (a -> b) -> f a -> f b
main =
  view
      ( Signal.map (show' 80) Mouse.position )
