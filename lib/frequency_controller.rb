class FrequencyController
  # PAGE = nil
  attr_reader :driver, :logger, :new_frequency

  def initialize(driver, logger)
    @driver = driver
    @logger = logger
    @new_frequency = nil
  end

  def put_down!
    # driver.navigate.to PAGE
    driver.find_element(:link, "Miner Configuration").click
    driver.find_element(:link, "Advanced Settings").click

    @new_frequency = calc_down_step
    frequency_selector.send_keys calc_down_step

    driver.find_element(:css, 'input.cbi-button.cbi-button-save.right').click
    logger.info "Frequency changed to #{new_frequency}"
  end

  private

  def frequency_selector
    @frequency_selector ||= driver.find_element(:id, 'ant_freq')
  end

  def current_frequency
    current_step = frequency_selector.attribute('value') + 'M'
    current_step = 'Default setting' if current_step == '0M'
    current_step
  end

  def calc_down_step
    list = frequency_selector.text.split("\n").map(&:strip)
    next_step_index = list.index(current_frequency) - 2
    next_step = next_step_index <= 0 ? '100M' : list[next_step_index]
  end
end
