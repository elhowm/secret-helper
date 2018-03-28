#! /usr/bin/env ruby

require 'selenium-webdriver'
require 'yaml'
require 'byebug'
require 'mail'
require 'logger'

require_relative 'settings'
require_relative 'lib/status_checker'
require_relative 'lib/frequency_controller'
require_relative 'lib/notifier'
require_relative 'lib/watcher'

errors_count = 0
loop do
  begin
    Watcher.instance.perform
    errors_count = 0
    sleep(180) # every 3 minutes
  rescue => exception
    Notifier.instance.notify_error! exception
    errors_count += 1
    exit(0) if errors_count >= 10
    sleep(30)
  end
end
