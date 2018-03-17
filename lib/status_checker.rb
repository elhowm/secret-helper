class StatusChecker
  attr_reader :driver, :max_temp

  PAGE = "http://#{SETTINGS['domain']}/miner_status.html"

  def initialize(driver)
    @driver = driver
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
    alarm
  end
end
