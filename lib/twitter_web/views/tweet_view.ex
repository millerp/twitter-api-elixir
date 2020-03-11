defmodule TwitterWeb.TweetView do
  use TwitterWeb, :view
  alias TwitterWeb.{TweetView, UserView}

  def render("index.json", %{tweets: tweets}) do
    %{data: render_many(tweets, TweetView, "tweet.json")}
  end

  def render("show.json", %{tweet: tweet}) do
    %{data: render_one(tweet, TweetView, "tweet.json")}
  end

  def render("tweet.json", %{tweet: tweet}) do
    tweet
    |> Map.from_struct()
    |> Map.put(:inserted_at, NaiveDateTime.to_string(tweet.inserted_at))
    |> Map.put(:updated_at, NaiveDateTime.to_string(tweet.updated_at))
    |> Map.put(:likes_count, length(tweet.likes))
    |> Map.put(:liked, !!tweet.liked)
    |> Map.take([
      :id,
      :content,
      :author,
      :likes_count,
      :liked,
      :inserted_at,
      :updated_at
    ])
    |> Map.put(:author, UserView.render("userinfo.json", user: tweet.author))
  end
end
