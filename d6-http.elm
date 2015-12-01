module D6 (main) where

import Html exposing (..)
import Html.Attributes exposing (style, src)
import Http
import Json.Decode as Json exposing (Decoder, (:=))
import Regex exposing (regex, replace)

import Signal exposing (Message, Mailbox, mailbox, send)
import Task exposing (Task, andThen)

redditGifs = "https://www.reddit.com/r/gifs/top.json"

redditDecoder : Decoder (List String)
redditDecoder =
    Json.at ["data", "children"] <|
        Json.list <|
            Json.at [ "data" ] <|
                Json.map (replace Regex.All (regex "gifv$") (\{match} -> "gif"))
                    ("url" := Json.string)

showGif s =
    div [ style [( "display", "inline" )] ]
        [ img
            [ style [( "width", "20%" )]
            , src s
            ] []
        ]

view gifsNow =
    div [] <| List.map showGif (List.take 10 gifsNow)

myMailbox : Mailbox (List String)
myMailbox = mailbox []

getImages : Task Http.Error (List String)
getImages =
    Http.get redditDecoder redditGifs

report : List String -> Task x ()
report ls =
    send myMailbox.address ls

port gifs : Task Http.Error ()
port gifs =
    getImages `andThen` report

main =
    Signal.map view myMailbox.signal
