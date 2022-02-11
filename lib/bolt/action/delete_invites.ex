defmodule Bolt.Action.DeleteInvites do
  @behaviour Bolt.Action

  alias Bolt.ModLog
  alias Nostrum.Api
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
  end

  def changeset(action, params) do
    action
    |> cast(params, [])
  end

  def run(_options, %{guild_id: guild_id}) do
    case Api.get_guild_invites(guild_id) do
      {:ok, invites} ->
        successful_deletions =
          invites
          |> Stream.map(&Api.delete_invite(&1.code))
          |> Enum.count(&match?({:ok, _code}, &1))

        ModLog.emit(
          guild_id,
          "AUTOMOD",
          "deleted #{successful_deletions} invites as part of action"
        )

      {:error, _reason} ->
        ModLog.emit(
          guild_id,
          "ERROR",
          "failed to run delete invite action due to discord API error trying to get invites"
        )
    end
  end

  defimpl String.Chars do
    def to_string(_options) do
      "delete all invites"
    end
  end
end
