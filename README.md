# Crawler

[![Travis](https://img.shields.io/travis/fredwu/crawler.svg)](https://travis-ci.org/fredwu/crawler)
[![Code Climate](https://img.shields.io/codeclimate/github/fredwu/crawler.svg)](https://codeclimate.com/github/fredwu/crawler)
[![CodeBeat](https://codebeat.co/badges/76916047-5b66-466d-91d3-7131a269899a)](https://codebeat.co/projects/github-com-fredwu-crawler-master)
[![Coverage](https://img.shields.io/coveralls/fredwu/crawler.svg)](https://coveralls.io/github/fredwu/crawler?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/crawler.svg)](https://hex.pm/packages/crawler)

A high performance web crawler in Elixir.

## Usage

```elixir
Crawler.crawl("http://elixir-lang.org", max_depths: 2)
```

## Configurations

| Option          | Type    | Default Value | Description |
|-----------------|---------|---------------|-------------|
| `:max_depths`   | integer | 3             | Maximum nested depth of pages to crawl.
| `:timeout`      | integer | 5000          | Timeout value for fetching a page, in ms.
| `:save_to`      | string  | nil           | When provided, the path for saving crawled pages.

## Features Backlog

Crawler is under active development, below is a non-comprehensive list of features to be implemented.

- [x] Set the maximum crawl depth.
- [x] Save to disk.
- [x] Set timeouts.
- [ ] Crawl assets (CSS and images, etc).
- [ ] The ability to manually stop/pause/restart the crawler.
- [ ] Restrict crawlable domains, paths or file types.
- [ ] Limit concurrent crawlers.
- [ ] Limit rate of crawling.
- [ ] Set crawler's user agent.
- [ ] The ability to retry a failed crawl.
- [ ] DSL for scraping page content.

## Changelog

Please see [CHANGELOG.md](CHANGELOG.md).

## License

Licensed under [MIT](http://fredwu.mit-license.org/).
