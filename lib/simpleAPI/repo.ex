defmodule SimpleAPI.Repo do
  use Ecto.Repo,
    otp_app: :simpleAPI,
    adapter: Ecto.Adapters.Postgres
end
