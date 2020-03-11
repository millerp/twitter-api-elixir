defmodule Twitter.Tweets.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitter.Accounts.User
  alias Twitter.Tweets.Like

  schema "tweets" do
    field :content, :string
    belongs_to :author, User, foreign_key: :user_id

    field :liked, :boolean, virtual: true

    has_many(:likes, Like)
    timestamps()
  end

  @doc false
  def changeset(tweet, attrs) do
    tweet
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
  end
end
