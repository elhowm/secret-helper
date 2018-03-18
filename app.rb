#! /usr/bin/env ruby

require 'selenium-webdriver'
require 'yaml'
require 'byebug'
require 'mail'
require 'logger'

SETTINGS = YAML::load_file(File.join(__dir__, 'settings.yml')).freeze

require_relative 'lib/status_checker'
require_relative 'lib/frequency_controller'
require_relative 'lib/notifier'

# Fetch and parse HTML document
driver = Selenium::WebDriver.for :chrome
logger = Logger.new('status.log')

checker = StatusChecker.new(driver, logger)

exit(0) unless checker.critical?

controller = FrequencyController.new(driver, logger)
controller.put_down!

Notifier.notify!(checker.max_temp, controller.new_frequency)
logger.info "Info letter sent"
