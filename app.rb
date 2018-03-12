#! /usr/bin/env ruby

require 'selenium-webdriver'
require 'yaml'
require 'byebug'

settings = YAML::load_file File.join(__dir__, 'settings.yml')

# Fetch and parse HTML document
alarm = false
driver = Selenium::WebDriver.for :chrome

driver.navigate.to "http://#{settings['domain']}/miner_status.html"
temps = driver.find_elements(:css, 'tr.cbi-section-table-row.cbi-rowstyle-1 > td:nth-child(7)')
temps.each do |temp|
  alarm ||= temp.text.to_i >= settings['critical_temp']
end
exit(0) unless alarm

driver.find_element(:link, "Miner Configuration").click

frequency_select = driver.find_element(:id, 'ant_freq')
list = frequency_select.text.split("\n").map(&:strip)

current_step = frequency_select.attribute('value') + 'M'
current_step = 'Default setting' if current_step == '0M'

next_step_index = list.index(current_step) - 2
next_step = next_step_index <= 0 ? '100M' : list[next_step_index]

frequency_select.send_keys next_step

driver.find_element(:css, 'input.cbi-button.cbi-button-save.right').click

puts 'DONE'
