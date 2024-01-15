defmodule BACWeb.Router do
  use BACWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BACWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BACWeb do
    pipe_through :api

    get "/", PageController, :home
    #resources "/customers", CustomerController, except: [:new, :edit]
    post "/customers/create", CustomerController, :create
    get "/customers", CustomerController, :index

    post "/create/accounts/:customer_id", AccountController, :create
    post "/create/accounts/v2/:customer_id", AccountController, :create_v2
    post "/create/bank_accounts/:customer_id", AccountController, :create_account
    get "/accounts", AccountController, :index

    post "/card/activate/:card_number", CardController, :activate_card

    post "/card/activate/v1/:id", CardController, :activate_card_v1


    resources "/service_activation_logs", ServiceActivationLogController, except: [:new, :edit]
    #resources "/cards", CardController, except: [:new, :edit]
    #resources "/accounts", AccountController, except: [:new, :edit]
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug

    # If using Plug.Router, make sure to add the `to`
    # forward "/sent_emails", to: Bamboo.SentEmailViewerPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", BACWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bAC, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard",
      additional_pages: [
        oban: Oban.LiveDashboard
      ] , metrics: BACWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
