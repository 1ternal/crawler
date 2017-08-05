defmodule Crawler.Linker.Prefixer do
  alias Crawler.Linker.PathFinder

  @doc """
  ## Examples

      iex> Prefixer.prefix("https://hello.world/")
      "../"

      iex> Prefixer.prefix("https://hello.world/page")
      "../"

      iex> Prefixer.prefix("https://hello.world/dir/page")
      "../../"
  """
  def prefix(current_url) do
    current_url
    |> PathFinder.find_path
    |> count_depth
    |> make_prefix
  end

  def count_depth(string, token \\ "/") do
    (
      string
      |> String.split(token)
      |> Enum.count
    ) - 1
  end

  defp make_prefix(depth) do
    String.duplicate("../", depth)
  end
end
