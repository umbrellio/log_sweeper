# LogSweeper   [![Gem Version](https://badge.fury.io/rb/log_sweeper.svg)](https://badge.fury.io/rb/log_sweeper) [![Build Status](https://travis-ci.org/umbrellio/log_sweeper.svg?branch=master)](https://travis-ci.org/umbrellio/log_sweeper) [![Coverage Status](https://coveralls.io/repos/github/umbrellio/log_sweeper/badge.svg?branch=master)](https://coveralls.io/github/umbrellio/log_sweeper?branch=master)

`LogSweeper` is a simple module designed for cleaning up log directories. It is designed to be used with ruby logger rotation. By default, it will remove all log files older than 10 days and will gzip all log files that look like rotated log files. For example, `production.log.20190228` will be gzipped and replaced with `production.log.20190228.gz`.

## Installation

Juts add `gem "log_sweeper"` to your Gemfile.

## Examples

```ruby
  # Clean up the log directory, by default it will delete logs older than 10 days and logs to STDOUT
  LogSweeper.run("log")

  # Customize some behavior
  LogSweeper.run("log", logs_lifetime_days_count: 5, logger: Logger.new("path/to/file.log"))
```
