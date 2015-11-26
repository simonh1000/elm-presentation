module D3 (main) where

import Signal exposing (Message, Mailbox, mailbox, message, foldp)
import Graphics.Input exposing (button)
import Graphics.Element exposing (Element, container, centered, middle, flow, down)
import Text exposing (height, fromString, monospace)

show' : Float -> a -> Element
show' sz =
    centered << monospace << Text.height sz << fromString << toString

view but sig =
    Signal.map (container 800 300 middle << flow down) <|
        Signal.map2 (\a b -> [a,b])
            (Signal.constant <| but)
            (Signal.map (\v -> show' 30 <| "Click count: " ++ (toString v)) sig)

-- Model of state
type alias Model = Int

buttonMailbox : Mailbox String
buttonMailbox =
    mailbox "initial value"

countClicks : Signal Model
countClicks =
    foldp (\_ acc -> acc + 1) 0 buttonMailbox.signal

buttonMessage : Message
buttonMessage =
    message buttonMailbox.address "I was clicked"

main =
    view
        (button buttonMessage "Click me")
        countClicks
