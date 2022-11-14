defmodule RadioTracker.Schemas.Play do
  use Ecto.Schema
  import Ecto.Changeset

  alias RadioTracker.Repo
  alias RadioTracker.Schemas.Track
  alias RadioTracker.Schemas.Recommendation

  schema "plays" do
    has_many :recommendations, Recommendation

    belongs_to :track, Track

    timestamps()
  end

  @doc false
  def changeset(play, attrs) do
    play
    |> cast(attrs, [:track_id])
    |> validate_required([:track_id])
  end

  def last_inserted do
    __MODULE__
    |> Ecto.Query.last(:inserted_at)
    |> Repo.one
    |> Repo.preload([:track])
  end
end