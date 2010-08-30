require Rails.root.to_s + "/lib/utilities"

config.cache_classes = true
config.action_controller.session = { :session_http_only => false }
config.whiny_nils = true
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_controller.allow_forgery_protection    = false
config.action_mailer.delivery_method = :test
