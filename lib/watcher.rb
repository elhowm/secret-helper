class Watcher
  attr_reader :driver, :logger

  LOGFILE_SIZE = 1024 * 1000 # 1 megabyte
  LOGFILES_COUNT = 7

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @logger = Logger.new('status.log', LOGFILES_COUNT, LOGFILE_SIZE)
  end

  def perform
    checker = StatusChecker.new(driver, logger)

    return unless checker.critical?

    controller = FrequencyController.new(driver, logger)
    controller.put_down!

    Notifier.instance.notify!(checker.max_temp, controller.new_frequency)
    logger.info "Info letter sent. Relaxing."
  rescue => exception
    Notifier.instance.notify_error! exception
  end
end
