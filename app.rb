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
require_relative 'lib/watcher'

loop do
  Watcher.instance.perform
  sleep(180) # every 3 minutes
end
