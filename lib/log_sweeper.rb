# frozen_string_literal: true

require "log_sweeper/version"

require "shellwords"
require "pathname"
require "logger"

module LogSweeper
  extend self

  def run(path, logs_lifetime_days_count: 10, logger: Logger.new(STDOUT))
    min_mtime = Time.now - (logs_lifetime_days_count.to_f * 24 * 3600)

    Pathname.new(path).each_child do |entry|
      next unless entry.file?

      filename = entry.basename.to_s

      if filename.match?(/\.log\b/) && entry.mtime < min_mtime
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
