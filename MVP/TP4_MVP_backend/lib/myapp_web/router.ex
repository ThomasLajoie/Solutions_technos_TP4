defmodule MyappWeb.Router do
  use MyappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyappWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug CORSPlug,
      origin: ["http://localhost:5173"],
      methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
      headers: ["Content-Type", "Authorization", "Accept"],
      max_age: 86400
  end

  scope "/", MyappWeb do
    pipe_through :browser
    get "/", PageController, :home
  end

  scope "/api", MyappWeb do
    pipe_through :api

    post "/register", UserController, :register
    post "/login", UserController, :login

    post "/addboat", BoatController, :add_boat
    get "/getboats", BoatController, :get_boats

    post "/addrace", RaceController, :add_race
    get "/getraces", RaceController, :get_races
    put "/updaterace/:race_id", RaceController, :update_race
    put "/setracefinished/:race_id", RaceController, :set_race_finished
    put "/updateraceresults/:race_id", RaceController, :update_race_results

    post "/addparticipanttorace", RaceController, :add_participant_to_race
    get "/getparticipantsforrace/:race_id", RaceController, :get_participants_for_race

    get "/getTest", UserController, :get_test
  end

  if Application.compile_env(:myapp, :dev_routes) do
    import Phoenix.LiveDashboard.Router
  end
end
