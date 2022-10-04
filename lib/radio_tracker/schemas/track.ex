defmodule RadioTracker.Schemas.Track do
  @moduledoc "The Track module"

  require Logger

  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias RadioTracker.Repo

  schema "tracks" do
    field :artist, :string
    field :song, :string

    has_many :recommendations, RadioTracker.Schemas.Recommendation

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:artist, :song])
    |> validate_required([:artist, :song])
  end

  def equals(%__MODULE__{artist: a1, song: t1}, %__MODULE__{artist: a2, song: t2}) do
    a1 === a2 && t1 === t2
  end

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
      preload: [:recommendations]

    Repo.all query

    # "#{track.inserted_at.hour}:#{track.inserted_at.minute}:#{track.inserted_at.second}"
  end

  def hearted do
    query =
      from t in __MODULE__,
      left_join: r in assoc(t, :recommendations),
      #where: t.inserted_at == ^ Timex.today,
      where: not is_nil(r.id),
      order_by: [desc: count(r.id)],
      group_by: t.id,
      select: t,
      preload: [:recommendations]

    Repo.all query
  end
end