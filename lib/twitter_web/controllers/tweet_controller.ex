defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller

  alias Twitter.{Tweets, Repo}
  alias Twitter.Tweets.{Tweet, Like}

  action_fallback TwitterWeb.FallbackController

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    tweets =
      Tweets.list_tweets
      |> Repo.preload([:author, :likes])
      |> Tweets.load_likes(current_user)
    render(conn, "index.json", tweets: tweets)
  end

  def list_my(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    tweets = Tweets.list_tweets_by_user!(current_user)
             |> Repo.preload([:author, :likes])
             |> Tweets.load_likes(current_user)
    render(conn, "index.json", tweets: tweets)
  end

  def create(conn, %{"tweet" => tweet_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    with {:ok, %Tweet{} = tweet} <- Tweets.create_tweet(
      tweet_params
      |> Map.merge(%{"user_id" => current_user.id})
    ) do
      tweet =
        tweet
        |> Repo.preload([:author, :likes])
        |> Tweets.load_like(current_user)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tweet_path(conn, :show, tweet))
      |> render("show.json", tweet: tweet)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    tweet = Tweets.get_tweet!(id)
            |> Repo.preload([:author, :likes])
            |> Tweets.load_like(current_user)

    render(conn, "show.json", tweet: tweet)
  end

  def update(conn, %{"id" => id, "tweet" => tweet_params}) do
    tweet = Tweets.get_tweet!(id)

    with {:ok, %Tweet{} = tweet} <- Tweets.update_tweet(tweet, tweet_params) do
      render(conn, "show.json", tweet: tweet)
    end
  end

  def delete(conn, %{"id" => id}) do
    tweet = Tweets.get_tweet!(id)

    with {:ok, %Tweet{}} <- Tweets.delete_tweet(tweet) do
      send_resp(conn, :no_content, "")
    end
  end

  def like(conn, %{"id" => id}) do
    tweet = Tweets.get_tweet!(id)
    current_user = Guardian.Plug.current_resource(conn)
    with {:ok, %Like{}} <- Tweets.like(current_user, tweet) do
      tweet =
        tweet
        |> Repo.preload([:author, :likes])
        |> Tweets.load_like(current_user)

      render(conn, "show.json", tweet: Tweets.load_like(tweet, current_user))
    end
  end

  def unlike(conn, %{"id" => id}) do
    tweet = Tweets.get_tweet!(id)
    current_user = Guardian.Plug.current_resource(conn)
    with {:ok, _} <- Tweets.unlike(tweet, current_user) do
      tweet =
        tweet
        |> Repo.preload([:author, :likes])
        |> Tweets.load_like(current_user)
      render(conn, "show.json", tweet: Tweets.load_like(tweet, current_user))
    end
  end
end
