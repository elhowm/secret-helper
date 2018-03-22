class Settings
  include Singleton

  SETTINGS_FILE_PATH = File.join(__dir__, 'settings.yml')

  def initialize
    refresh
  end

  def info
    @info.clone
  end

  def refresh
    @info =
      if File.exists? SETTINGS_FILE_PATH
        YAML::load_file(SETTINGS_FILE_PATH)
      else
        settings_keys = %w(domain mail_login mail_password receiver_email critical_temp)
        settings_keys.inject({}) do |settings, key|
          settings.merge(key => ENV[key.upcase])
        end
      end
    info
  end
end
