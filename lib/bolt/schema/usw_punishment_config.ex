defmodule Bolt.Schema.USWPunishmentConfig do
  @moduledoc "Configuration for the punishment executed by USW."

  import Ecto.Changeset
  use Ecto.Schema

  @primary_key false
  schema "usw_punishment_config" do
    field(:guild_id, :id, primary_key: true)
    field(:duration, :integer)
    field(:punishment, :string)
    field(:escalate, :boolean, default: false)
    field(:data, :map, default: %{})
  end

  @spec changeset(Changeset.t(), map()) :: Changeset.t()
  def changeset(config, params \\ %{}) do
    config
    |> cast(params, [:guild_id, :duration, :punishment, :escalate, :data])
    |> validate_required([:guild_id, :duration, :punishment])
    |> validate_inclusion(:punishment, existing_punishments())
  end

  @spec existing_punishments :: [String.t()]
  def existing_punishments do
    [
      "TEMPROLE",
      "TIMEOUT"
    ]
  end
end
