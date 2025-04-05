defmodule ElixirTemplateWeb.Auth.AuthHelpers do
  @moduledoc """
  Helper functions for authentication in LiveViews.
  """
  alias ElixirTemplate.Accounts

  @doc """
  Creates a form for password registration.
  """
  def password_registration_form(_socket) do
    AshPhoenix.Form.for_create(Accounts.User, :register_with_password, domain: Accounts)
  end

  @doc """
  Creates a form for password sign-in.
  """
  def password_sign_in_form(_socket) do
    AshPhoenix.Form.for_read(Accounts.User, :sign_in_with_password, domain: Accounts)
  end

  @doc """
  Creates a form for magic link request.
  """
  def magic_link_form(_socket) do
    AshPhoenix.Form.for_action(Accounts.User, :request_magic_link, domain: Accounts)
  end

  @doc """
  Extracts error messages from a changeset or form.
  """
  def extract_error_message(form) when is_map(form) do
    cond do
      is_struct(form, Ecto.Changeset) && form.errors ->
        Enum.map_join(form.errors, ", ", fn {field, {msg, _opts}} ->
          "#{Phoenix.Naming.humanize(field)} #{msg}"
        end)
      is_struct(form, Phoenix.HTML.Form) && form.errors ->
        Enum.map_join(form.errors, ", ", fn {field, msg} ->
          "#{Phoenix.Naming.humanize(field)} #{msg}"
        end)
      true ->
        "An error occurred"
    end
  end

  def extract_error_message(_error) do
    "Invalid credentials or an error occurred"
  end

  @doc """
  Extracts error messages from a changeset.
  """
  def extract_error_message(changeset) when is_map(changeset) do
    if changeset.errors do
      Enum.map_join(changeset.errors, ", ", fn {field, {msg, _opts}} ->
        "#{Phoenix.Naming.humanize(field)} #{msg}"
      end)
    else
      "An error occurred"
    end
  end

  def extract_error_message(_error) do
    "Invalid credentials or an error occurred"
  end
end
