# frozen_string_literal: true

require "log_sweeper/version"

require "shellwords"
require "pathname"
require "logger"

module LogSweeper
  extend self

  # Clean up provided log directory
  # @param path [String, Pathname] path to the log directory to clean
  # @param logs_lifetime_days_count [Numeric] number of days to keep the logs
  # @param logger [Logger] logger to use
  def run(path, logs_lifetime_days_count: 10, logger: Logger.new(STDOUT))
    lifetime_threshold = logs_lifetime_days_count * 24 * 3600

    Pathname.new(path).each_child do |entry|
      next unless entry.file?

      filename = entry.basename.to_s

      if filename.match?(/\.log\b/) && Time.now - entry.mtime > lifetime_threshold
        logger.info "deleting #{entry}"
        entry.delete
      elsif filename.match?(/\.log\.\d+$/)
        logger.info "gzipping #{entry}"
        compress_file(entry)
        entry.delete
      else
        logger.info "skipping #{entry}"
      end
    end

    true
  end

  private

  def compress_file(file_name)
    zipped = "#{file_name}.gz"

    Zlib::GzipWriter.open(zipped) do |gz|
      gz.write IO.binread(file_name)
    end
  end
end
