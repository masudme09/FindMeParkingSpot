defmodule ParkinWeb.Router do
  use ParkinWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Parkin.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ParkinWeb do
    pipe_through :browser
    resources "/sessions", SessionController, only: [:new, :create]
    get "parking/search", ParkingsearchController, :search
    post "parking/search", ParkingsearchController, :submit
    resources "/parking_slots", ParkingSlotController
  end

  scope "/", ParkinWeb do
    pipe_through [:browser, :browser_auth, :ensure_auth]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", ParkinWeb do
    pipe_through [:browser, :browser_auth]
    get "/", PageController, :index
  end

  scope "/", ParkinWeb do
    pipe_through [:browser, :browser_auth]

    resources "/users", UserController, only: [:new, :create]
  end

  scope "/", ParkinWeb do
    pipe_through [:browser, :browser_auth, :ensure_auth]

    resources "/users", UserController, only: [:index, :show, :edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ParkinWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ParkinWeb.Telemetry
    end
  end
end
