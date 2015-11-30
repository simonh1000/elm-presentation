module D2 (main) where

import Signal exposing (Message, Mailbox, mailbox, message)
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
            sig

buttonMailbox : Mailbox String
buttonMailbox =
    mailbox "Waiting to be clicked"

buttonMessage : Message
buttonMessage =
    message buttonMailbox.address "I was clicked"

main =
    view
        (button buttonMessage "Click me")
        (Signal.map (\v -> show' 30 <|
            "buttonMailbox value: " ++ v) buttonMailbox.signal)
