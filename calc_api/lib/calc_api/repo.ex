defmodule CalcApi.Repo do
  use Ecto.Repo,
    otp_app: :calc_api,
    adapter: Ecto.Adapters.Postgres
end
