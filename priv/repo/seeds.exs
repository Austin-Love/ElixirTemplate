# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Or via the alias:
#
#     mix ecto.seed

alias ElixirTemplate.Repo
alias ElixirTemplate.Accounts

# Only seed in dev environment
if Mix.env() == :dev do
  # Create a default dev user for quick login
  case Accounts.register_user(%{
         email: "dev@example.com",
         username: "devuser",
         password: "Password123!"
       }) do
    {:ok, user} ->
      # Auto-confirm the dev user
      user
      |> Ecto.Changeset.change(confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second))
      |> Repo.update!()

      IO.puts("Created dev user: dev@example.com / Password123!")

    {:error, _changeset} ->
      IO.puts("Dev user already exists: dev@example.com / Password123!")
  end
end
