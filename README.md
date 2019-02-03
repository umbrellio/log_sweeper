# LogSweeper   [![Gem Version](https://badge.fury.io/rb/log_sweeper.svg)](https://badge.fury.io/rb/log_sweeper) [![Build Status](https://travis-ci.org/umbrellio/log_sweeper.svg?branch=master)](https://travis-ci.org/umbrellio/log_sweeper) [![Coverage Status](https://coveralls.io/repos/github/umbrellio/log_sweeper/badge.svg?branch=master)](https://coveralls.io/github/umbrellio/log_sweeper?branch=master)

`LogSweeper` is a simple module for cleaning up log directories.

It is designed to be used with Ruby logger rotation. By default, it will remove all log files older than 10 days and will gzip all log files that look like rotated log files. For example, `production.log.20190228` will be gzipped and replaced with `production.log.20190228.gz`. It logs what it's doing using the provided logger which defaults to `STDOUT` logger.

## Installation

Juts add `gem "log_sweeper"` to your Gemfile.

## Examples

```ruby
  # Just use the defaults
  LogSweeper.run("log")

  # Customize logs lifetime and logger
  LogSweeper.run("log", logs_lifetime_days_count: 5, logger: Logger.new("/path/to/file.log"))

  # In case you don't want any logging and deleting any logs
  LogSweeper.run("log", logs_lifetime_days_count: Float::INFINITY, logger: Logger.new(nil))
```

The best way to use this module is to run it via cron, for example you can use [whenever](https://github.com/javan/whenever) gem with similar config in `schedule.rb` file:

```ruby
every 1.hour do
  runner "LogRotator.run(Rails.root.join('log'))"
end
```

## License

Released under MIT License.

## Authors

Created by Yuri Smirnov.

<a href="https://github.com/umbrellio/">
<img style="float: left;" src="https://umbrellio.github.io/Umbrellio/supported_by_umbrellio.svg" alt="Supported by Umbrellio" width="439" height="72">
</a>
