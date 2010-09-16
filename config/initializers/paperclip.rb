if Rails.env.production?
  PAPERCLIP_CONFIG = {
    :storage        => :s3,
    :s3_credentials => Rails.root.join("config/s3.yml"),
    :bucket         => "threed-staging",
    :path           => ":attachment/:id/:style.:extension"
  }
else
  PAPERCLIP_CONFIG = {}
end
