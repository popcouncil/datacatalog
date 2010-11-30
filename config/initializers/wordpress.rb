if File.exist?(RAILS_ROOT + '/config/wordpress.yml') and (wordpress = YAML.load_file(RAILS_ROOT + '/config/wordpress.yml')[RAILS_ENV])
  ENV['WORDPRESS_URL'] ||= wordpress['wordpress_url']
  ENV['WORDPRESS_KEYCODE'] ||= wordpress['keycode']
end
require 'net/http'
require 'openssl'
