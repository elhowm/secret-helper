class Notifier
  include Singleton

  OPTIONS = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    user_name: SETTINGS['mail_login'],
    password: SETTINGS['mail_password'],
    authentication: 'plain',
    enable_starttls_auto: true
  }.freeze

  def initialize
    Mail.defaults { delivery_method(:smtp, Notifier::OPTIONS) }
  end

  def notify!(temperature, new_frequency)
    Mail.deliver do
      to SETTINGS['receiver_email']
      from SETTINGS['mail_login']
      subject 'Oh, Crape!'
      body "Hello, temperature was '#{temperature}C'. Frequency changed to #{new_frequency}."
    end
  end

  def notify_error!(exception)
    Mail.deliver do
      to SETTINGS['dev_email']
      from SETTINGS['mail_login']
      subject 'Helper error!'
      body "'#{exception}'.\n #{exception.backtrace}."
    end
  end
end
