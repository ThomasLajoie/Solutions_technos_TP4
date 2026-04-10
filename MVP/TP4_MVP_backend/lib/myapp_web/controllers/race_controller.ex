defmodule MyappWeb.RaceController do
  use MyappWeb, :controller
  alias Mongo

  @collection "races"

  # POST /api/addrace
  def add_race(conn, params) do
    with {:ok, name} <- Map.fetch(params, "name"),
         {:ok, location} <- Map.fetch(params, "location"),
         {:ok, date} <- Map.fetch(params, "date") do

      race = %{
        name: name,
        location: location,
        date: date,
        finished: false,
        participants: []
      }

      case Mongo.insert_one(:mongo, @collection, race) do
        {:ok, result} ->
          json(conn, %{
            message: "Race added",
            id: result.inserted_id
          })

        {:error, reason} ->
          IO.inspect(reason, label: "MONGO ERROR")
          conn
          |> put_status(500)
          |> json(%{error: inspect(reason)})
      end
    else
      :error ->
        conn
        |> put_status(400)
        |> json(%{error: "Missing parameters (name, location, date)"})
    end
  end

  # GET /api/getraces
  def get_races(conn, _params) do
    races =
      Mongo.find(:mongo, @collection, %{})
      |> Enum.to_list()

    json(conn, races)
  end

  # POST /api/addparticipanttorace
  def add_participant_to_race(conn, params) do
    with {:ok, race_id} <- Map.fetch(params, "race_id"),
         {:ok, boat_id} <- Map.fetch(params, "boat_id"),
         {:ok, boat_name} <- Map.fetch(params, "boat_name"),
         {:ok, sail_number} <- Map.fetch(params, "sail_number"),
         {:ok, boat_class} <- Map.fetch(params, "boat_class"),
         {:ok, helm_name} <- Map.fetch(params, "helm_name"),
         {:ok, object_id} <- decode_object_id(race_id),
         {:ok, race} <- get_race_by_id(object_id),
         :ok <- ensure_race_not_finished(race),
         :ok <- ensure_participant_not_already_registered(race, boat_id, sail_number) do

      participant = %{
        id: generate_participant_id(),
        boat_id: boat_id,
        boat_name: boat_name,
        sail_number: sail_number,
        boat_class: boat_class,
        helm_name: helm_name,
        result: nil,
        position: nil,
        points: nil,
        inserted_at: DateTime.utc_now() |> DateTime.to_iso8601()
      }

      filter = %{"_id" => object_id}

      update = %{
        "$push" => %{
          "participants" => participant
        }
      }

      case Mongo.update_one(:mongo, @collection, filter, update) do
        {:ok, %{matched_count: 0}} ->
          conn
          |> put_status(404)
          |> json(%{error: "Race not found"})

        {:ok, _result} ->
          json(conn, %{
            message: "Participant added to race",
            race_id: race_id,
            participant: participant
          })

        {:error, reason} ->
          conn
          |> put_status(500)
          |> json(%{error: inspect(reason)})
      end
    else
      :error ->
        conn
        |> put_status(400)
        |> json(%{
          error:
            "Missing parameters (race_id, boat_id, boat_name, sail_number, boat_class, helm_name)"
        })

      {:error, :invalid_object_id} ->
        conn
        |> put_status(400)
        |> json(%{error: "Invalid race_id"})

      {:error, :race_not_found} ->
        conn
        |> put_status(404)
        |> json(%{error: "Race not found"})

      {:error, :race_finished} ->
        conn
        |> put_status(400)
        |> json(%{error: "Cannot add participant to a finished race"})

      {:error, :participant_already_registered} ->
        conn
        |> put_status(409)
        |> json(%{error: "Participant already registered for this race"})

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: inspect(reason)})
    end
  end

  def get_participants_for_race(conn, %{"race_id" => race_id}) do
  with {:ok, object_id} <- decode_object_id(race_id),
       {:ok, race} <- get_race_by_id(object_id) do
    participants = Map.get(race, "participants", [])
    json(conn, participants)
  else
    {:error, :invalid_object_id} ->
      conn
      |> put_status(400)
      |> json(%{error: "Invalid race_id"})

    {:error, :race_not_found} ->
      conn
      |> put_status(404)
      |> json(%{error: "Race not found"})
  end
end

  defp decode_object_id(id) when is_binary(id) do
    try do
      {:ok, BSON.ObjectId.decode!(id)}
    rescue
      _ -> {:error, :invalid_object_id}
    end
  end

  defp get_race_by_id(object_id) do
    case Mongo.find_one(:mongo, @collection, %{"_id" => object_id}) do
      nil -> {:error, :race_not_found}
      race -> {:ok, race}
    end
  end

  defp ensure_race_not_finished(race) do
    if Map.get(race, "finished", false) do
      {:error, :race_finished}
    else
      :ok
    end
  end

  defp ensure_participant_not_already_registered(race, boat_id, sail_number) do
    participants = Map.get(race, "participants", [])

    already_exists =
      Enum.any?(participants, fn participant ->
        participant["boat_id"] == boat_id or participant["sail_number"] == sail_number
      end)

    if already_exists do
      {:error, :participant_already_registered}
    else
      :ok
    end
  end

  defp generate_participant_id do
    System.unique_integer([:positive, :monotonic])
  end
end
