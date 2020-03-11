defmodule TwitterWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :twitter,
      module: TwitterWeb.Auth.Guardian,
      error_handler: TwitterWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end