defmodule ElixirTemplateWeb.Auth.RegisterLive do
  use ElixirTemplateWeb, :live_view
  alias ElixirTemplateWeb.Auth.AuthHelpers
  import Phoenix.Component
  alias ElixirTemplateWeb.CoreComponents


  def render(assigns) do
    ~H"""
    <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8 bg-primaryBg-light dark:bg-primaryBg-dark text-primaryText-light dark:text-primaryText-dark">
      <div class="sm:mx-auto sm:w-full sm:max-w-sm flex flex-col items-center">
        <ElixirTemplateWeb.Components.ThemeToggle.theme_toggle />
        <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight">
          Create your account
        </h2>
      </div>

      <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
        <div class="mb-4 border-b border-neutral-200 dark:border-neutral-700">
          <ul class="flex justify-around flex-wrap flex-grow mb-px text-sm font-medium text-center w-full" role="tablist">
            <li class="flex-grow text-center w-1/2" role="presentation">
              <.link
                class={["w-full inline-block p-4 border-b-2 rounded-t-lg hover:text-primaryAccent-light dark:hover:text-primaryAccent-dark", @active_tab == :password && "border-primaryAccent-light dark:border-primaryAccent-dark text-primaryAccent-light dark:text-primaryAccent-dark"]}
                patch={~p"/register/password"}
              >
                Email & Password
              </.link>
            </li>
            <li class="flex-grow text-center w-1/2" role="presentation">
              <.link
                class={["w-full inline-block p-4 border-b-2 rounded-t-lg hover:text-primaryAccent-light dark:hover:text-primaryAccent-dark", @active_tab == :magic_link && "border-primaryAccent-light dark:border-primaryAccent-dark text-primaryAccent-light dark:text-primaryAccent-dark"]}
                patch={~p"/register/magic-link"}
              >
                Magic Link
              </.link>
            </li>
          </ul>
        </div>

        <div class="tab-content">
          <div class={["tab-pane", @active_tab != :password && "hidden"]}>
            <.form
              :if={@active_tab == :password}
              :let={f}
              for={@password_form}
              phx-change="validate_password"

              phx-trigger-action={@trigger_action}
              action={~p"/auth/user/password/register"}
              method="POST"
            >
              <div class="space-y-4">
                <CoreComponents.input
                  field={@password_form[:email]}
                  type="email"
                  label="Email address"
                  required
                  autocomplete="email"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />

                <CoreComponents.input
                  field={@password_form[:username]}
                  type="text"
                  label="Username"
                  required
                  autocomplete="username"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />

                <CoreComponents.input
                  field={@password_form[:password]}
                  type="password"
                  label="Password"
                  required
                  autocomplete="new-password"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />

                <CoreComponents.input
                  field={@password_form[:password_confirmation]}
                  type="password"
                  label="Confirm Password"
                  required
                  autocomplete="new-password"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />

                <div class="mt-2 text-sm text-red-600 dark:text-red-400">
                  <%= if @error_message do %>
                    <p><%= @error_message %></p>
                  <% end %>
                </div>

                <div class="mt-6">
                  <button
                    type="submit"
                    class="flex w-full justify-center rounded-md bg-primaryAccent-light dark:bg-primaryAccent-dark px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-primary-500 dark:hover:bg-primary-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primaryAccent-light dark:focus-visible:outline-primaryAccent-dark"
                  >
                    Register
                  </button>
                </div>
              </div>
            </.form>
          </div>

          <div class={["tab-pane", @active_tab != :magic_link && "hidden"]}>
            <.form
              :let={f}
              :if={@active_tab == :magic_link}
              for={@magic_link_form}
              phx-change="validate_magic_link"
              phx-trigger-action={@trigger_action}
              action={~p"/auth/user/magic_link/request"}
              method="POST"
            >
              <div class="space-y-4">
                <CoreComponents.input
                  field={@magic_link_form[:email]}
                  id="magic_link_email"
                  type="email"
                  label="Email address"
                  required
                  autocomplete="email"
                  class="block w-full rounded-md border-0 py-1.5 text-primaryText-light dark:text-primaryText-dark shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-600 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-primaryAccent-light dark:focus:ring-primaryAccent-dark sm:text-sm sm:leading-6 bg-white dark:bg-gray-800"
                />

                <div class="mt-2 text-sm text-red-600 dark:text-red-400">
                  <%= if @error_message do %>
                    <p><%= @error_message %></p>
                  <% end %>
                </div>

                <div class="mt-6">
                  <button
                    type="submit"
                    class="flex w-full justify-center rounded-md bg-primaryAccent-light dark:bg-primaryAccent-dark px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-primary-500 dark:hover:bg-primary-400 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primaryAccent-light dark:focus-visible:outline-primaryAccent-dark"
                  >
                    Send Magic Link
                  </button>
                </div>
              </div>
            </.form>
          </div>
        </div>

        <p class="mt-10 text-center text-sm text-secondaryText-light dark:text-secondaryText-dark">
          Already have an account?
          <.link navigate={~p"/sign-in"} class="font-semibold leading-6 text-primaryAccent-light dark:text-primaryAccent-dark hover:text-primary-500 dark:hover:text-primary-400">
            Sign in
          </.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Register")
      |> assign(:password_form, AuthHelpers.password_registration_form(socket) |> to_form())
      |> assign(:magic_link_form, AuthHelpers.magic_link_form(socket) |> to_form())
      |> assign(:active_tab, :password)
      |> assign(:error_message, nil)
      |> assign(:trigger_action, false)

    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    active_tab = socket.assigns.live_action || :password

    {:noreply, assign(socket, :active_tab, active_tab)}
  end

  def handle_event("validate_password", %{"user" => params}, socket) do
    form = socket.assigns.password_form |> AshPhoenix.Form.validate(params, errors: false)
    {:noreply, assign(socket, :password_form, to_form(form))}
  end

  def handle_event("validate_magic_link", %{"user" => params}, socket) do
    form = socket.assigns.magic_link_form |> AshPhoenix.Form.validate(params, errors: false)
    {:noreply, assign(socket, :magic_link_form, to_form(form))}
  end
end
