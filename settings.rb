settings_file_path = File.join(__dir__, 'settings.yml')
SETTINGS =
  if File.exists? settings_file_path
    YAML::load_file(settings_file_path)
  else
    settings_keys = %w(domain mail_login mail_password receiver_email critical_temp)
    settings_keys.inject({}) do |settings, key|
      settings.merge(key => ENV[key.upcase])
    end
  end
