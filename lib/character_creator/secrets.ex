defmodule ElixirTemplate.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        ElixirTemplate.Accounts.User,
        _opts
      ) do
    Application.fetch_env(:elixir_template, :token_signing_secret)
  end
end
