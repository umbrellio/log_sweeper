# frozen_string_literal: true

RSpec.describe LogSweeper do
  it "has a version number" do
    expect(LogSweeper::VERSION).not_to be(nil)
  end

  def run!(**options)
    LogSweeper.run("spec/log", **options)
  end

  def create_file!(filename, mtime = nil)
    path = log_dir.join(filename)
    path.write("Hello world!")
    path.utime(mtime, mtime) if mtime
  end

  describe ".run" do
    before do
      log_dir.rmtree
      log_dir.mkdir

      create_file!("old file.log", old_time)
      create_file!("old ignored file.log123", old_time)
      create_file!("recent file.log")
      create_file!("recent file.log.1")
      create_file!("ignored file.log.1.smth")
      create_file!("ignored file 2.txt")

      sweeper_logger.formatter = proc { |*, msg| "#{msg}\n" }
    end

    let(:log_dir) { Pathname.new(__dir__).join("log") }
    let(:old_time) { Time.now - (20 * 24 * 3600) }
    let(:sweeper_logger) { Logger.new(sweeper_log) }
    let(:sweeper_log) { StringIO.new }

    it "sweeps the logs" do
      run!(logger: sweeper_logger)

      expect(log_dir.children.map { |x| x.basename.to_s }).to match_array([
        "ignored file 2.txt",
        "ignored file.log.1.smth",
        "old ignored file.log123",
        "recent file.log.1.gz",
        "recent file.log",
      ])

      expect(sweeper_log.tap(&:rewind).read.lines).to match_array([
        "deleting spec/log/old file.log\n",
        "gzipping spec/log/recent file.log.1\n",
        "skipping spec/log/ignored file 2.txt\n",
        "skipping spec/log/ignored file.log.1.smth\n",
        "skipping spec/log/recent file.log\n",
        "skipping spec/log/old ignored file.log123\n",
      ])
    end

    context "disabling logs_lifetime_days_count and logger" do
      it "doesn't delete any logs" do
        run!(logs_lifetime_days_count: Float::INFINITY, logger: Logger.new(nil))

        expect(log_dir.children.map { |x| x.basename.to_s }).to match_array([
          "ignored file 2.txt",
          "ignored file.log.1.smth",
          "old file.log",
          "old ignored file.log123",
          "recent file.log.1.gz",
          "recent file.log",
        ])
      end
    end
  end
end
