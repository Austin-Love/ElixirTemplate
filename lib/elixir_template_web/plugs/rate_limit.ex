defmodule ElixirTemplateWeb.Plugs.RateLimit do
  @moduledoc """
  Simple ETS-based rate limiting plug.

  ## Usage in router

      plug ElixirTemplateWeb.Plugs.RateLimit, max_requests: 10, interval_ms: 60_000

  Limits requests per IP address. Defaults to 60 requests per 60 seconds.
  """

  import Plug.Conn

  @behaviour Plug

  @default_max_requests 60
  @default_interval_ms 60_000

  @impl true
  def init(opts) do
    table = opts[:table] || :rate_limit_requests

    unless :ets.whereis(table) != :undefined do
      :ets.new(table, [:set, :public, :named_table])
    end

    %{
      max_requests: opts[:max_requests] || @default_max_requests,
      interval_ms: opts[:interval_ms] || @default_interval_ms,
      table: table
    }
  end

  @impl true
  def call(conn, %{max_requests: max, interval_ms: interval, table: table}) do
    key = client_key(conn)
    now = System.monotonic_time(:millisecond)

    case :ets.lookup(table, key) do
      [{^key, count, started_at}] when now - started_at < interval ->
        if count >= max do
          conn
          |> put_resp_header("retry-after", to_string(div(interval - (now - started_at), 1000)))
          |> send_resp(429, "Too Many Requests")
          |> halt()
        else
          :ets.update_counter(table, key, {2, 1})
          conn
        end

      _ ->
        :ets.insert(table, {key, 1, now})
        conn
    end
  end

  defp client_key(conn) do
    conn.remote_ip |> :inet.ntoa() |> to_string()
  end
end
