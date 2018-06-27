module ContactList.Commands exposing (fetchContactList)

import Commands exposing (apiUrl)
import ContactList.Messages exposing (ContactListMsg(FetchContactList))
import ContactList.Request as Request
import GraphQL.Client.Http as Http
import Messages exposing (Msg(ContactListMsg))
import Task


fetchContactList : Int -> String -> Cmd Msg
fetchContactList pageNumber search =
    search
        |> Request.fetchContactList pageNumber
        |> Http.sendQuery apiUrl
        |> Task.attempt FetchContactList
        |> Cmd.map ContactListMsg
