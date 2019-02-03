# frozen_string_literal: true

require "log_sweeper/version"

# require "shellwords"
# require "pathname"

module LogSweeper
  def self.run(path, logs_lifetime_days_count: 10)
    min_mtime = Time.now - (logs_lifetime_days_count.to_f * 24 * 3600)

    Pathname.new(path).each_child do |entry|
      filename = entry.basename.to_s
      next unless entry.file? && filename.match?(/\.log\b/)

      if entry.mtime < min_mtime
        puts "deleting #{entry}"
        entry.delete
      elsif filename.match?(/\.log\.\d+$/)
        puts "gzipping #{entry}"
        system "gzip #{Shellwords.escape(entry)}"
      end
    end

    true
  end

  # def compress_file(file_name)
  #   zipped = "#{file_name}.gz"

  #   Zlib::GzipWriter.open(zipped) do |gz|
  #     gz.write IO.binread(file_name)
  #   end
  # end
end
