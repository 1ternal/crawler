defmodule Crawler.Worker do
  @moduledoc """
  Starts the crawl tasks.
  """

  use GenServer

  alias Crawler.{Fetcher, Store, Store.Page}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def handle_cast(_req, state) do
    state
    |> Fetcher.fetch
    |> state[:parser].parse
    |> mark_processed

    {:noreply, state}
  end

  def cast(pid, term \\ []) do
    GenServer.cast(pid, term)
  end

  defp mark_processed(%Page{url: url}), do: Store.processed(url)
  defp mark_processed(_),               do: nil
end
