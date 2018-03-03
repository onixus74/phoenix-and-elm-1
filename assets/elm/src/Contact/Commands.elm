module Contact.Commands exposing (fetchContact)

import Commands exposing (apiUrl)
import Contact.Request as Request
import Contact.Messages exposing (ContactMsg(FetchContact))
import GraphQL.Client.Http as Http
import Messages exposing (Msg(ContactMsg))
import Task exposing (Task)


fetchContact : Int -> Cmd Msg
fetchContact id =
    id
        |> Request.fetchContact
        |> Http.sendQuery apiUrl
        |> Task.attempt FetchContact
        |> Cmd.map ContactMsg
