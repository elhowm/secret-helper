class StatusChecker
  attr_reader :driver, :logger, :max_temp

  PAGE = "http://#{SETTINGS['domain']}/cgi-bin/minerStatus.cgi"

  def initialize(driver, logger)
    @driver = driver
    @logger = logger
    @max_temp = 0
  end

  def critical?
    alarm = false
    driver.navigate.to PAGE
    temps = driver.find_elements(:css, 'tr.cbi-section-table-row.cbi-rowstyle-1 > td:nth-child(7)')
    temps.each do |temp|
      @max_temp = temp.text.to_i if temp.text.to_i > max_temp
      alarm ||= temp.text.to_i >= SETTINGS['critical_temp']
    end
    log! alarm
    alarm
  end

  def log!(alarm)
    if alarm
      logger.warn("Status critical. Temperature is #{max_temp}C.")
    else
      logger.info('Status normal. Relaxing.')
    end
  end
end
