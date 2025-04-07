defmodule ElixirTemplateWeb.Auth.AuthHelpers do
  @moduledoc """
  Helper functions for authentication in LiveViews.
  
  This module provides utility functions for handling authentication-related
  operations in Phoenix LiveViews, including form creation for registration,
  sign-in, and error message extraction.
  """
  alias ElixirTemplate.Accounts

  @doc """
  Creates a form for password registration.
  
  ## Parameters
  
    * `_socket` - The LiveView socket (unused but kept for consistency)
  
  ## Returns
  
    * A form for the register_with_password action
  
  ## Examples
  
      iex> password_registration_form(socket)
      %AshPhoenix.Form{}
  """
  def password_registration_form(_socket) do
    AshPhoenix.Form.for_action(Accounts.User, :register_with_password, domain: Accounts, as: "user")
  end

  @doc """
  Creates a form for password sign-in.
  
  ## Parameters
  
    * `_socket` - The LiveView socket (unused but kept for consistency)
  
  ## Returns
  
    * A form for the sign_in_with_password action
  
  ## Examples
  
      iex> password_sign_in_form(socket)
      %AshPhoenix.Form{}
  """
  def password_sign_in_form(_socket) do
    AshPhoenix.Form.for_action(Accounts.User, :sign_in_with_password, domain: Accounts, as: "user")
  end

  @doc """
  Creates a form for magic link request.
  
  ## Parameters
  
    * `_socket` - The LiveView socket (unused but kept for consistency)
  
  ## Returns
  
    * A form for the request_magic_link action
  
  ## Examples
  
      iex> magic_link_form(socket)
      %AshPhoenix.Form{}
  """
  def magic_link_form(_socket) do
    AshPhoenix.Form.for_action(Accounts.User, :request_magic_link, domain: Accounts, as: "user")
  end

  @doc """
  Extracts error messages from a changeset or form.
  
  Handles different types of form objects including Ecto.Changeset and Phoenix.HTML.Form,
  extracting human-readable error messages.
  
  ## Parameters
  
    * `form` - The form or changeset containing errors
  
  ## Returns
  
    * A string containing formatted error messages
  
  ## Examples
  
      iex> extract_error_message(%Ecto.Changeset{errors: [email: {"is invalid", []}]})
      "Email is invalid"
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

  @doc """
  Extracts error messages from any other error type.
  
  This is a fallback function for handling errors that don't match the previous patterns.
  
  ## Parameters
  
    * `_error` - Any error type not matching previous patterns
  
  ## Returns
  
    * A generic error message
  """
  def extract_error_message(_error) do
    "Invalid credentials or an error occurred"
  end
end
