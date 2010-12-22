class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  belongs_to :location

  validates_presence_of :user
  #validates_presence_of :tag
  validates_presence_of :location

  def self.tags
    @tags ||= ['All', '-------------'] + Tag.all(:conditions => {:kind => 'topics'}).collect { |i| [i.name, i.id] }
#    Better query, but cucumber isn't taking it
#    Tag.all(:conditions => "taggings.taggable_type = 'DataRecord' AND taggings.taggable_id IS NOT NULL",
#      :joins => 'LEFT JOIN taggings ON taggings.id = tags.id',
#      :order => 'tags.name').collect { |i| [i.name, i.id] }
  end

  def alert!
    Notifier.deliver_data_record_alert(self) if self.by_email?
    # Some other stuff for sms. We don't have an sms framework hooked up yet.
  end
end
