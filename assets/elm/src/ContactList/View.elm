module ContactList.View exposing (indexView)

import Shared.View exposing (warningMessage)
import Contact.View exposing (contactView)
import Html exposing (Html, a, div, h3, input, li, text)
import Html.Attributes
    exposing
        ( class
        , classList
        , id
        , type_
        , placeholder
        , value
        )
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Keyed
import Messages
    exposing
        ( Msg
            ( HandleFormSubmit
            , HandleSearchInput
            , Paginate
            , ResetSearch
            )
        )
import Model
    exposing
        ( ContactList
        , Model
        , RemoteData(NotRequested, Requesting, Failure, Success)
        )


indexView : Model -> Html Msg
indexView model =
    div [ id "home_index" ]
        (viewContent model)


viewContent : Model -> List (Html Msg)
viewContent model =
    case model.contactList of
        NotRequested ->
            [ text "" ]

        Requesting ->
            [ searchSection model
            , warningMessage
                "fa fa-spin fa-cog fa-2x fa-fw"
                "Searching for contacts"
                (text "")
            ]

        Failure error ->
            [ warningMessage "fa fa-meh-o fa-stack-2x" error (text "") ]

        Success page ->
            [ searchSection model
            , paginationList page
            , div []
                [ contactsList model page ]
            , paginationList page
            ]


searchSection : Model -> Html Msg
searchSection model =
    div
        [ class "filter-wrapper" ]
        [ div [ class "overview-wrapper" ]
            [ h3 []
                [ text (header model) ]
            ]
        , div
            [ class "form-wrapper" ]
            [ Html.form [ onSubmit HandleFormSubmit ]
                [ resetButton model "reset"
                , input
                    [ type_ "search"
                    , placeholder "Search contacts..."
                    , value model.search
                    , onInput HandleSearchInput
                    ]
                    []
                ]
            ]
        ]


header : Model -> String
header model =
    case model.contactList of
        Success page ->
            headerText page.total_entries

        _ ->
            ""


headerText : Int -> String
headerText totalEntries =
    let
        contactWord =
            if totalEntries == 1 then
                "contact"
            else
                "contacts"
    in
        if totalEntries == 0 then
            ""
        else
            (toString totalEntries) ++ " " ++ contactWord ++ " found"


contactsList : Model -> ContactList -> Html Msg
contactsList model page =
    if page.total_entries > 0 then
        page.entries
            |> List.map contactView
            |> Html.Keyed.node "div" [ class "cards-wrapper" ]
    else
        warningMessage
            "fa fa-meh-o fa-stack-2x"
            "No contacts found..."
            (resetButton model "btn")


paginationList : ContactList -> Html Msg
paginationList page =
    page.total_pages
        |> List.range 1
        |> List.map (paginationLink page.page_number)
        |> Html.Keyed.ul [ class "pagination" ]


paginationLink : Int -> Int -> ( String, Html Msg )
paginationLink currentPage page =
    let
        classes =
            classList [ ( "active", currentPage == page ) ]
    in
        ( toString page
        , li []
            [ a [ classes, onClick (Paginate page) ] [] ]
        )


resetButton : Model -> String -> Html Msg
resetButton model className =
    let
        hidden =
            model.search == ""

        classes =
            classList [ ( className, True ), ( "hidden", hidden ) ]
    in
        a [ classes, onClick ResetSearch ]
            [ text "Reset search" ]
