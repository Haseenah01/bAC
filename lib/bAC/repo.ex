defmodule BAC.Repo do
  use Ecto.Repo,
    otp_app: :bAC,
    adapter: Ecto.Adapters.Postgres
end
