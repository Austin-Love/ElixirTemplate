defmodule ElixirTemplateWeb.HomeLive do
  use ElixirTemplateWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-6">Phoenix Authentication with phx.gen.auth</h1>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">What is phx.gen.auth?</h2>
            <p>
              phx.gen.auth is a mix task that generates a pre-built authentication system for Phoenix applications.
              It provides a complete authentication solution with features like:
            </p>
            <ul class="list-disc pl-5 mt-2 space-y-1">
              <li>User registration and confirmation</li>
              <li>Login and session management</li>
              <li>Password reset functionality</li>
              <li>Account settings and email changes</li>
              <li>Session token-based authentication</li>
            </ul>
          </div>
        </div>

        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">Key Features</h2>
            <ul class="list-disc pl-5 mt-2 space-y-1">
              <li>Secure password hashing with bcrypt</li>
              <li>CSRF protection and secure session handling</li>
              <li>Email confirmation workflows</li>
              <li>Account lockout protection</li>
              <li>Integration with Phoenix LiveView</li>
              <li>Customizable templates and components</li>
            </ul>
          </div>
        </div>

        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">Implementation Details</h2>
            <p>
              The authentication system uses Ecto schemas and changesets for data validation,
              Phoenix controllers and LiveViews for handling requests, and secure token generation
              for session management.
            </p>
            <p class="mt-2">
              User passwords are securely hashed using bcrypt, and authentication tokens
              are generated with cryptographically secure methods.
            </p>
          </div>
        </div>

        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title">Resources</h2>
            <div class="mt-2 space-y-2">
              <a href="https://github.com/phoenixframework/phoenix/tree/master/installer/lib/phx_new/templates/phx_gen_auth" class="link link-primary" target="_blank">
                GitHub Repository
              </a>
              <a href="https://hexdocs.pm/phoenix/mix_phx_gen_auth.html" class="link link-primary" target="_blank">
                Official Documentation
              </a>
              <a href="https://dashbit.co/blog/a-new-authentication-solution-for-phoenix" class="link link-primary" target="_blank">
                Dashbit Blog: Authentication Solution for Phoenix
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    </Layouts.app>
    """
  end
end
