module Update exposing (update)

import List exposing (sortBy, reverse)
import AnimationFrame
import Keyboard exposing (KeyCode)
import Model exposing (Model, State(Paused, Flying), View(Game, Leaderboard))
import Msg exposing (Msg(Tick, KeyUp, KeyDown, GotSavedScore, GotLeaderboard))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick intervalLengthMs ->
            Model.interate { model | intervalLengthMs = intervalLengthMs }

        GotSavedScore highScore ->
            ( { model | highScore = highScore }, Cmd.none )

        GotLeaderboard leaderboard ->
            ( { model
                | leaderboard = sortBy .score leaderboard |> reverse
              }
            , Cmd.none
            )

        KeyDown code ->
            case code of
                32 ->
                    -- Spacebar
                    ( { model
                        | state =
                            if model.state == Paused then
                                Flying
                            else
                                Paused
                        , view = Game
                      }
                    , Cmd.none
                    )

                37 ->
                    -- Left
                    ( { model | leftThruster = True }, Cmd.none )

                38 ->
                    -- Up
                    ( { model | mainEngine = True }, Cmd.none )

                39 ->
                    -- Right
                    ( { model | rightThruster = True }, Cmd.none )

                76 ->
                    -- L: Leaderboard
                    ( { model
                        | view =
                            if model.view == Leaderboard then
                                Game
                            else
                                Leaderboard
                        , state = Paused
                      }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        KeyUp code ->
            case code of
                37 ->
                    ( { model | leftThruster = False }, Cmd.none )

                38 ->
                    ( { model | mainEngine = False }, Cmd.none )

                39 ->
                    ( { model | rightThruster = False }, Cmd.none )

                82 ->
                    init

                _ ->
                    ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        , AnimationFrame.diffs Tick
        ]



-- Init


init : ( Model, Cmd Msg )
init =
    ( Model.initialModel, Cmd.none )
