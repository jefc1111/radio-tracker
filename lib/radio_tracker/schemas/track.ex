defmodule RadioTracker.Schemas.Track do
  @moduledoc "The Track module"

  require Logger

  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias RadioTracker.Repo
  alias RadioTracker.Paginator
  alias RadioTracker.Schemas.Play

  schema "tracks" do
    field :artist, :string
    field :song, :string

    has_many :plays, Play

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:artist, :song])
    |> validate_required([:artist, :song])
  end

  def equals(%__MODULE__{artist: a1, song: s1}, %__MODULE__{artist: a2, song: s2}) do
    a1 === a2 && s1 === s2
  end

  def equals(%__MODULE__{}, _), do: false

  def as_summary(%__MODULE__{artist: a, song: s}), do: "#{a} - #{s}"

  def last_inserted do
    __MODULE__
    |> Ecto.Query.last(:inserted_at)
    |> Repo.one
  end

  def last_ten do
    query =
      from t in __MODULE__,
      order_by: [desc: t.id],
      limit: 10,
      preload: [plays: :recommendations]

    Repo.all query
  end

  def hearted(params) do
    query =
      from t in __MODULE__,
      inner_join: p in assoc(t, :plays),
      inner_join: r in assoc(p, :recommendations),
      on: r.play_id == p.id,
      select: t,
      order_by: [desc: count(r.id)],
      group_by: t.id,
      preload: [plays: :recommendations]
    Paginator.paginate(query, params["page"])
  end

  def total_recs(track) do
    track.plays
    |> Enum.map(fn p -> length(p.recommendations) end)
    |> Enum.sum
  end

  def get_by_artist_song(artist, song) do
    query = from(t in __MODULE__, where: t.artist == ^artist, where: t.song == ^song)

    Repo.one(query)
  end
end
