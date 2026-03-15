defmodule ElixirTemplate.Workers.ExampleWorker do
  @moduledoc """
  Example Oban worker demonstrating background job processing.

  ## Usage

      %{email: "user@example.com", type: "welcome"}
      |> ElixirTemplate.Workers.ExampleWorker.new()
      |> Oban.insert()

  ## With scheduling

      %{email: "user@example.com", type: "reminder"}
      |> ElixirTemplate.Workers.ExampleWorker.new(scheduled_at: DateTime.add(DateTime.utc_now(), 3600))
      |> Oban.insert()
  """

  use Oban.Worker, queue: :default, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => _email, "type" => _type}}) do
    # Replace with your job logic
    :ok
  end
end
