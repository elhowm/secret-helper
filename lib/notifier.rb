class Notifier
  include Singleton

  OPTIONS = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    user_name: Settings.instance.info['mail_login'],
    password: Settings.instance.info['mail_password'],
    authentication: 'plain',
    enable_starttls_auto: true
  }.freeze

  def initialize
    Mail.defaults { delivery_method(:smtp, Notifier::OPTIONS) }
  end

  def notify!(temperature, new_frequency)
    Mail.deliver do
      to Settings.instance.info['receiver_email']
      from Settings.instance.info['mail_login']
      subject 'Oh, Crape!'
      body "Hello, temperature was '#{temperature}C'. Frequency changed to #{new_frequency}."
    end
  end

  def notify_error!(exception)
    Mail.deliver do
      to Settings.instance.info['dev_email']
      from Settings.instance.info['mail_login']
      subject 'Helper error!'
      body "'#{exception}'.\n #{exception.backtrace}."
    end
  end
end
