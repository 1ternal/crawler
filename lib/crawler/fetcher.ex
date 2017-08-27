defmodule Crawler.Fetcher do
  @moduledoc """
  Fetches pages and perform tasks on them.
  """

  alias __MODULE__.{Policer, Recorder, Requester}
  alias Crawler.{Snapper, Store.Page}

  def fetch(opts) do
    with {:ok, opts} <- Policer.police(opts),
         {:ok, opts} <- Recorder.record(opts)
    do
      opts[:retrier].perform(fn -> fetch_url(opts) end, opts)
    end
  end

  defp fetch_url(opts) do
    case Requester.make(opts) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
        fetch_url_200(body, headers, opts)
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        fetch_url_non_200(status_code, opts)
      {:error, %HTTPoison.Error{reason: reason}} ->
        fetch_url_failed(reason, opts)
    end
  end

  defp fetch_url_200(body, headers, opts) do
    with opts        <- Map.put(opts, :headers, headers),
         {:ok, _}    <- Recorder.store_page(opts[:url], body),
         {:ok, opts} <- record_referrer_url(opts),
         {:ok, _}    <- snap_page(body, opts)
    do
      return_page(body, opts)
    end
  end

  defp fetch_url_non_200(status_code, opts) do
    {:error, "Failed to fetch #{opts[:url]}, status code: #{status_code}"}
  end

  defp fetch_url_failed(reason, opts) do
    {:error, "Failed to fetch #{opts[:url]}, reason: #{reason}"}
  end

  defp record_referrer_url(opts) do
    {:ok, Map.put(opts, :referrer_url, opts[:url])}
  end

  defp snap_page(body, opts) do
    if opts[:save_to] do
      Snapper.snap(body, opts)
    else
      {:ok, ""}
    end
  end

  defp return_page(body, opts) do
    %{
      page: %Page{url: opts[:url], body: body},
      opts: opts
    }
  end
end
