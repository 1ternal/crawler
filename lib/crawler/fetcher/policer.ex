defmodule Crawler.Fetcher.Policer do
  alias Crawler.Store

  @doc """
  ## Examples

      iex> Policer.police([depth: 1, max_depths: 2, url: "http://policer/"])
      {:ok, [depth: 1, max_depths: 2, url: "http://policer/"]}

      iex> Crawler.Store.add("http://policer/exist/")
      iex> Policer.police([depth: 1, max_depths: 2, url: "http://policer/exist/"])
      {:error, "Fetch failed 'not_fetched_yet?', with opts: [depth: 1, max_depths: 2, url: \\\"http://policer/exist/\\\"]."}

      iex> Policer.police([depth: 2, max_depths: 2])
      {:error, "Fetch failed 'within_fetch_depth?', with opts: [depth: 2, max_depths: 2]."}
  """
  def police(opts) do
    with {_, true} <- within_fetch_depth?(opts),
         {_, true} <- not_fetched_yet?(opts)
    do
      {:ok, opts}
    else
      {fail_type, _} -> police_error(fail_type, opts)
    end
  end

  defp within_fetch_depth?(opts) do
    {:within_fetch_depth?, opts[:depth] < opts[:max_depths]}
  end

  defp not_fetched_yet?(opts) do
    {:not_fetched_yet?, !Store.find(opts[:url])}
  end

  defp police_error(fail_type, opts) do
    {:error, "Fetch failed '#{fail_type}', with opts: #{Kernel.inspect(opts)}."}
  end
end
