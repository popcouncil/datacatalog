module Slugs
  def self.make(object, attribute)
    slug_prefix = attribute.to_s.parameterize
    slug, n = slug_prefix, 2

    loop do
      break unless object.class.find_by_slug(slug)
      slug, n = "#{slug_prefix}-#{n}"
    end

    slug
  end
end
