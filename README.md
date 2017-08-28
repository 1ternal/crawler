# Crawler

[![Travis](https://img.shields.io/travis/fredwu/crawler.svg)](https://travis-ci.org/fredwu/crawler)
[![Code Climate](https://img.shields.io/codeclimate/github/fredwu/crawler.svg)](https://codeclimate.com/github/fredwu/crawler)
[![CodeBeat](https://codebeat.co/badges/76916047-5b66-466d-91d3-7131a269899a)](https://codebeat.co/projects/github-com-fredwu-crawler-master)
[![Coverage](https://img.shields.io/coveralls/fredwu/crawler.svg)](https://coveralls.io/github/fredwu/crawler?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/crawler.svg)](https://hex.pm/packages/crawler)

A high performance web crawler in Elixir, with worker pooling and rate limiting via [OPQ](https://github.com/fredwu/opq).

## Features

Crawler is under active development, below is a non-comprehensive list of features (to be) implemented.

- [x] Crawl assets (javascript, css and images).
- [x] Save to disk.
- [x] Hook for scraping content.
- [x] Restrict crawlable domains, paths or content types.
- [x] Limit concurrent crawlers.
- [x] Limit rate of crawling.
- [x] Set the maximum crawl depth.
- [x] Set timeouts.
- [x] Set retries strategy.
- [x] Set crawler's user agent.
- [ ] Manually stop/pause/restart the crawler.

## Architecture

Below is a very high level architecture diagram demonstrating how Crawler works.

![](https://rawgit.com/fredwu/crawler/master/architecture.svg)

## Usage

```elixir
Crawler.crawl("http://elixir-lang.org", max_depths: 2)
```

There are several ways to access the crawled page data:

1. Use [`Crawler.Store`](https://hexdocs.pm/crawler/Crawler.Store.html)
2. Tap into the registry([?](https://hexdocs.pm/elixir/Registry.html)) [`Crawler.Store.DB`](lib/crawler/store.ex)
3. Use your own [scraper](#custom-modules)
4. If the `:save_to` option is set, pages will be saved to disk in addition to the above mentioned places
5. Provide your own [custom parser](#custom-modules) and manage how data is stored and accessed yourself

## Configurations

| Option          | Type    | Default Value               | Description |
|-----------------|---------|-----------------------------|-------------|
| `:assets`       | list    | `[]`                        | Whether to fetch any asset files, available options: `"css"`, `"js"`, `"images"`.
| `:save_to`      | string  | `nil`                       | When provided, the path for saving crawled pages.
| `:workers`      | integer | `10`                        | Maximum number of concurrent workers for crawling.
| `:interval`     | integer | `0`                         | Rate limit control - number of milliseconds before crawling more pages, defaults to `0` which is effectively no rate limit.
| `:max_depths`   | integer | `3`                         | Maximum nested depth of pages to crawl.
| `:timeout`      | integer | `5000`                      | Timeout value for fetching a page, in ms.
| `:user_agent`   | string  | `Crawler/x.x.x (...)`       | User-Agent value sent by the fetch requests.
| `:url_filter`   | module  | `Crawler.Fetcher.UrlFilter` | Custom URL filter, useful for restricting crawlable domains, paths or content types.
| `:retrier`      | module  | `Crawler.Fetcher.Retrier`   | Custom fetch retrier, useful for retrying failed crawls.
| `:scraper`      | module  | `Crawler.Scraper`           | Custom scraper, useful for scraping content as soon as the parser parses it.
| `:parser`       | module  | `Crawler.Parser`            | Custom parser, useful for handling parsing differently or to add extra functionalities.

## Custom Modules

It is possible to swap in your custom logic as shown in the configurations section. Your custom modules need to conform to their respective behaviours:

### Retrier

See [`Crawler.Fetcher.Retrier`](lib/crawler/fetcher/retrier.ex).

Crawler uses [ElixirRetry](https://github.com/safwank/ElixirRetry)'s exponential backoff strategy by default.

```elixir
defmodule CustomRetrier do
  @behaviour Crawler.Fetcher.Retrier.Spec
end
```

### URL Filter

See [`Crawler.Fetcher.UrlFilter`](lib/crawler/fetcher/url_filter.ex).

```elixir
defmodule CustomUrlFilter do
  @behaviour Crawler.Fetcher.UrlFilter.Spec
end
```

### Scraper

See [`Crawler.Scraper`](lib/crawler/scraper.ex).

```elixir
defmodule CustomScraper do
  @behaviour Crawler.Scraper.Spec
end
```

### Parser

See [`Crawler.Parser`](lib/crawler/parser.ex).

```elixir
defmodule CustomParser do
  @behaviour Crawler.Parser.Spec
end
```

## API Reference

Please see https://hexdocs.pm/crawler.

## Changelog

Please see [CHANGELOG.md](CHANGELOG.md).

## License

Licensed under [MIT](http://fredwu.mit-license.org/).
