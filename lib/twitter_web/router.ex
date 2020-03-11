defmodule TwitterWeb.Router do
  use TwitterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug TwitterWeb.Auth.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwitterWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", TwitterWeb do
    pipe_through :api
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
  end

  scope "/api", TwitterWeb do
    pipe_through [:api, :auth]
    get "/tweets/my", TweetController, :list_my
    post("/tweets/:id/like", TweetController, :like)
    delete("/tweets/:id/like", TweetController, :unlike)
    resources "/tweets", TweetController, except: [:edit]
  end

end
