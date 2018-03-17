#! /usr/bin/env ruby

require 'selenium-webdriver'
require 'yaml'
require 'byebug'
require 'mail'

SETTINGS = YAML::load_file(File.join(__dir__, 'settings.yml')).freeze

require_relative 'lib/status_checker'
require_relative 'lib/freequency_controller'
require_relative 'lib/notifier'

# Fetch and parse HTML document
driver = Selenium::WebDriver.for :chrome
checker = StatusChecker.new(driver)

exit(0) unless checker.critical?

controller = FreequencyController.new(driver)
controller.put_down!

Notifier.notify!(checker.max_temp, controller.new_freequency)
puts 'DONE'
