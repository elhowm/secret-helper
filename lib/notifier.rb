class Notifier
  OPTIONS = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'gmail.com',
    user_name: SETTINGS['mail_login'],
    password: SETTINGS['mail_password'],
    authentication: 'plain',
    enable_starttls_auto: true
  }.freeze

  def self.notify!(temperature, new_freequency)
    Mail.defaults { delivery_method(:smtp, Notifier::OPTIONS) }
    Mail.deliver do
      to 'elhowm@gmail.com'
      from 'johnytoastfish@gmail.com'
      subject 'Oh, Crape!'
      body "Hello, temperature was '#{temperature}C'. Freequency changed to #{new_freequency}."
    end
  end
end