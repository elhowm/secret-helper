class Watcher
  include Singleton

  attr_reader :driver, :logger, :capabilities, :operations_count

  LOGFILE_SIZE = 1024 * 1000 # 1 megabyte
  LOGFILES_COUNT = 7

  def initialize
    @capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w[headless disable-gpu no-sandbox] }
    )
    @logger = Logger.new('status.log', LOGFILES_COUNT, LOGFILE_SIZE)
    @operations_count = 0
    @driver = nil
    load_new_driver!
  end

  def perform
    load_new_driver! if operations_count > 480 # about once per day..
    Settings.instance.refresh
    checker = StatusChecker.new(driver, logger)

    return inc_operations! unless checker.critical?

    controller = FrequencyController.new(driver, logger)
    controller.put_down!

    Notifier.instance.notify!(checker.max_temp, controller.new_frequency)
    logger.info "Info letter sent. Relaxing."
    inc_operations!
  end

  private

  def inc_operations!
    @operations_count += 1
  end

  def load_new_driver!
    @driver.quit unless @driver.nil?
    @driver = nil
    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: @capabilities
    @operations_count = 0
    logger.info "New driver loaded."
  end
end
