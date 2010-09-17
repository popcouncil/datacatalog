ActiveRecord::Base.extend Juixe::Acts::Voteable::ClassMethods

Comment.class_eval do
  acts_as_voteable
end
