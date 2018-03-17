class FreequencyController
  # PAGE = nil
  attr_reader :driver, :new_freequency

  def initialize(driver)
    @driver = driver
    @new_freequency = nil
  end

  def put_down!
    # driver.navigate.to PAGE
    driver.find_element(:link, "Miner Configuration").click

    @new_freequency = calc_down_step
    freequency_selector.send_keys calc_down_step

    driver.find_element(:css, 'input.cbi-button.cbi-button-save.right').click
  end

  private

  def freequency_selector
    @freequency_selector ||= driver.find_element(:id, 'ant_freq')
  end

  def current_freequency
    current_step = freequency_selector.attribute('value') + 'M'
    current_step = 'Default setting' if current_step == '0M'
    current_step
  end

  def calc_down_step
    list = freequency_selector.text.split("\n").map(&:strip)
    next_step_index = list.index(current_freequency) - 2
    next_step = next_step_index <= 0 ? '100M' : list[next_step_index]
  end
end
