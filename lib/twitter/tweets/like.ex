defmodule Twitter.Tweets.Like do

  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Accounts.User
  alias Twitter.Tweets.{Tweet, Like}

  @required_fields ~w(user_id tweet_id)a

  schema "likes" do
    belongs_to(:user, User, foreign_key: :user_id)
    belongs_to(:tweet, Tweet, foreign_key: :tweet_id)

    timestamps()
  end

  @doc false
  def changeset(%Like{} = like, attrs) do
    like
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_id, name: :likes_user_id_tweet_id_index, message: "already liked")
  end
end