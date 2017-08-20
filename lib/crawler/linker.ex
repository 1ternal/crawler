defmodule Crawler.Linker do
  alias Crawler.Linker.{Prefixer, PathFinder, PathOffliner}

  @doc """
  ## Examples

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "page1"
      iex> )
      "http://hello.world/dir/page1/index.html"

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "page1.html"
      iex> )
      "http://hello.world/dir/page1.html"

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "../page1"
      iex> )
      "http://hello.world/page1/index.html"

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "../page1.html"
      iex> )
      "http://hello.world/page1.html"

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "http://thank.you/page1"
      iex> )
      "http://thank.you/page1/index.html"

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "http://thank.you/page1.html"
      iex> )
      "http://thank.you/page1.html"

      iex> Linker.offline_url(
      iex>   "http://hello.world/dir/page",
      iex>   "http://thank.you/"
      iex> )
      "http://thank.you/index.html"
  """
  def offline_url(current_url, link) do
    current_url
    |> url(link)
    |> PathOffliner.transform
  end

  @doc """
  ## Examples

      iex> Linker.offline_link(
      iex>   "http://hello.world/dir/page",
      iex>   "page1"
      iex> )
      "../../../hello.world/dir/page1/index.html"

      iex> Linker.offline_link(
      iex>   "http://hello.world/dir/page",
      iex>   "page1.html"
      iex> )
      "../../../hello.world/dir/page1.html"

      iex> Linker.offline_link(
      iex>   "http://hello.world/dir/page",
      iex>   "../page1"
      iex> )
      "../../../hello.world/page1/index.html"

      iex> Linker.offline_link(
      iex>   "http://hello.world/dir/page",
      iex>   "../page1.html"
      iex> )
      "../../../hello.world/page1.html"

      iex> Linker.offline_link(
      iex>   "http://hello.world/dir/page",
      iex>   "http://thank.you/page1"
      iex> )
      "../../../thank.you/page1/index.html"

      iex> Linker.offline_link(
      iex>   "http://hello.world/dir/page",
      iex>   "http://thank.you/page1.html"
      iex> )
      "../../../thank.you/page1.html"
  """
  def offline_link(current_url, link) do
    with link        <- PathOffliner.prep_link(current_url, link),
         current_url <- PathOffliner.prep_url(current_url, link),
         current_url <- link(current_url, link)
    do
      PathOffliner.transform(current_url)
    end
  end

  @doc """
  ## Examples

      iex> Linker.url(
      iex>   "http://another.domain:8888/page",
      iex>   "/dir/page2"
      iex> )
      "http://another.domain:8888/dir/page2"

      iex> Linker.url(
      iex>   "http://another.domain:8888/parent/page",
      iex>   "dir/page2"
      iex> )
      "http://another.domain:8888/parent/dir/page2"
  """
  def url(current_url, link) do
    Path.join(
      PathFinder.find_scheme(current_url),
      PathFinder.find_full_path(current_url, link, false)
    )
  end

  @doc """
  ## Examples

      iex> Linker.link(
      iex>   "http://another.domain/page.html",
      iex>   "/dir/page2"
      iex> )
      "../another.domain/dir/page2"

      iex> Linker.link(
      iex>   "http://another.domain/page",
      iex>   "/dir/page2"
      iex> )
      "../../another.domain/dir/page2"

      iex> Linker.link(
      iex>   "http://another.domain/parent/page",
      iex>   "dir/page2"
      iex> )
      "../../../another.domain/parent/dir/page2"

      iex> Linker.link(
      iex>   "http://another.domain/parent/page",
      iex>   "../dir/page2"
      iex> )
      "../../../another.domain/dir/page2"
  """
  def link(current_url, link) do
    Path.join(
      Prefixer.prefix(current_url),
      PathFinder.find_full_path(current_url, link)
    )
  end
end
