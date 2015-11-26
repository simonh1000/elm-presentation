module D5 (main) where

import Graphics.Input exposing (button)
import Graphics.Element exposing (Element, container, centered, middle, flow, down)
import Text exposing (height, fromString, monospace)
import Time exposing (second)

import Signal exposing (Message, Mailbox, mailbox, send)
import Task exposing (Task, andThen)

show' : Float -> a -> Element
show' sz =
    centered << monospace << Text.height sz << fromString << toString

view v = show' 30 <| "myMailbox = " ++ (toString v)

myMailbox : Mailbox Int
myMailbox = Signal.mailbox 0

myTask : Task x ()
myTask =
    -- Signal.send myMailbox.address 1
    Task.sleep 2000
        `andThen`
            (\_ -> Signal.send myMailbox.address 1)

port example : Task x ()
port example = myTask

main =
    Signal.map view myMailbox.signal
