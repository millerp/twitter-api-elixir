defmodule Twitter.Accounts.Follow do

  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Accounts.User
  alias Twitter.Accounts.Follow

  @required_fields ~w(user_id follow_user_id)a

  schema "follows" do
    belongs_to(:user, User, foreign_key: :user_id)
    belongs_to(:follow_user, User, foreign_key: :follow_user_id)

    timestamps()
  end

  @doc false
  def changeset(%Follow{} = follow, attrs) do
    follow
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id, name: :follow_user_id_user_id_index, message: "already follow")
  end
end