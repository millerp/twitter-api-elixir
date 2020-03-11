defmodule Twitter.Tweets do
  @moduledoc """
  The Tweets context.
  """

  import Ecto.Query, warn: false
  alias Twitter.Repo

  alias Twitter.Tweets.Tweet
  alias Twitter.Tweets.Like
  alias Twitter.Accounts.User

  @doc """
  Returns the list of tweets.

  ## Examples

      iex> list_tweets()
      [%Tweet{}, ...]

  """
  def list_tweets do
    Repo.all(Tweet)
  end

  def list_tweets_by_user!(user) do
    Repo.all(from(t in Tweet, where: t.user_id == ^user.id))
  end

  @doc """
  Gets a single tweet.

  Raises `Ecto.NoResultsError` if the Tweet does not exist.

  ## Examples

      iex> get_tweet!(123)
      %Tweet{}

      iex> get_tweet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tweet!(id), do: Repo.get!(Tweet, id)

  @doc """
  Creates a tweet.

  ## Examples

      iex> create_tweet(%{field: value})
      {:ok, %Tweet{}}

      iex> create_tweet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tweet(attrs \\ %{}) do
    %Tweet{}
    |> Tweet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tweet.

  ## Examples

      iex> update_tweet(tweet, %{field: new_value})
      {:ok, %Tweet{}}

      iex> update_tweet(tweet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tweet(%Tweet{} = tweet, attrs) do
    tweet
    |> Tweet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tweet.

  ## Examples

      iex> delete_tweet(tweet)
      {:ok, %Tweet{}}

      iex> delete_tweet(tweet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tweet(%Tweet{} = tweet) do
    Repo.delete(tweet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tweet changes.

  ## Examples

      iex> change_tweet(tweet)
      %Ecto.Changeset{source: %Tweet{}}

  """
  def change_tweet(%Tweet{} = tweet) do
    Tweet.changeset(tweet, %{})
  end

  def load_like(tweet, nil), do: tweet
  def load_like(tweet, user) do
    case find_like(tweet, user) do
      %Tweet{} -> Map.put(tweet, :liked, true)
      _ -> tweet
    end
  end

  def load_likes(tweets, nil), do: tweets
  def load_likes(tweets, user) do
    tweets
    |> Enum.map(fn tweet -> load_like(tweet, user) end)
  end

  defp find_like(%Tweet{} = tweet, %User{} = user) do
    query = from(l in Like, where: l.tweet_id == ^tweet.id and l.user_id == ^user.id)

    Repo.one(query)
  end

  def like(user, tweet) do
    like = %Like{}

    params = %{
      user_id: user.id,
      tweet_id: tweet.id
    }

    like
    |> Like.changeset(params)
    |> Repo.insert()
  end

  def unlike(tweet, user) do
    like = find_like(tweet, user)
    Repo.delete(like)
  end

end
