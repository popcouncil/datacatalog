if Rails.env.production?
  PAPERCLIP_CONFIG = {
    :storage        => :s3,
    :s3_credentials => {
      :access_key_id     => ENV["S3_ACCESS_KEY"],
      :secret_access_key => ENV["S3_SECRET_KEY"]
    }
    :bucket         => "threed-staging",
    :path           => ":attachment/:id/:style.:extension"
  }
else
  PAPERCLIP_CONFIG = {}
end
