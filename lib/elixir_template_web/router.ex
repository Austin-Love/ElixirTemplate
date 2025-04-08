defmodule ElixirTemplateWeb.Router do
  use ElixirTemplateWeb, :router

  import ElixirTemplateWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirTemplateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
    # plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes accessible to all users
  scope "/", ElixirTemplateWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Routes that require authentication
  scope "/", ElixirTemplateWeb do
    # pipe_through [:browser, :require_authenticated_user]

    # live_session :authenticated_routes,
    #   on_mount: [{ElixirTemplateWeb.UserAuth, :ensure_authenticated}] do
    #   live "/settings", SettingsLive, :edit
    #   # Add other authenticated routes here
    # end
  end

  # Routes that are only accessible to unauthenticated users
  scope "/", ElixirTemplateWeb do
    # pipe_through [:browser, :redirect_if_user_is_authenticated]

    # live_session :unauthenticated_routes,
    #   on_mount: [{ElixirTemplateWeb.UserAuth, :redirect_if_user_is_authenticated}] do
    #   live "/users/register", UserRegistrationLive, :new
    #   live "/users/log_in", UserLoginLive, :new
    #   live "/users/reset_password", UserForgotPasswordLive, :new
    #   live "/users/reset_password/:token", UserResetPasswordLive, :edit
    # end

    # post "/users/log_in", UserSessionController, :create
  end

  scope "/", ElixirTemplateWeb do
    # pipe_through [:browser]

    # delete "/users/log_out", UserSessionController, :delete
    # get "/users/confirm", UserConfirmationController, :new
    # post "/users/confirm", UserConfirmationController, :create
    # get "/users/confirm/:token", UserConfirmationController, :edit
    # post "/users/confirm/:token", UserConfirmationController, :update
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixir_template, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirTemplateWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ElixirTemplateWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ElixirTemplateWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", ElixirTemplateWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{ElixirTemplateWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
