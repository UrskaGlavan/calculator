defmodule CalcApiWeb.Router do
  use CalcApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CalcApiWeb do
    pipe_through :api
    post "/add", CalcController, :add
    post "/sub", CalcController, :sub
    post "/mul", CalcController, :mul
    post "/div", CalcController, :div
    get "/history", CalcController, :history
    delete "/history", CalcController, :clear_history
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:calc_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CalcApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
