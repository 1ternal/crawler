defmodule Crawler do
  @moduledoc """
  A high performance web crawler in Elixir.
  """

  use Application

  alias Crawler.{Options, Store, WorkerSupervisor, Worker, QueueHandler}

  def start(_type, _args) do
    Store.init
    WorkerSupervisor.start_link
  end

  def crawl(url, opts \\ []) do
    opts
    |> Options.assign_defaults
    |> Options.assign_url(url)
    |> QueueHandler.enqueue
  end

  def crawl_now(opts) do
    {:ok, worker} = WorkerSupervisor.start_child(opts)

    Worker.cast(worker, opts)
  end
end
