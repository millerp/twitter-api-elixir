defmodule Twitter.Accounts.Blocked do

  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Accounts.User
  alias Twitter.Accounts.Blocked

  @required_fields ~w(user_id blocked_user_id)a

  schema "blocked_users" do
    belongs_to(:user, User, foreign_key: :user_id)
    belongs_to(:blocked_user, User, foreign_key: :blocked_user_id)

    timestamps()
  end

  @doc false
  def changeset(%Blocked{} = blocked, attrs) do
    blocked
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id, name: :blocked_user_id_user_id_index, message: "already blocked")
  end
end