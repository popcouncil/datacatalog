class Document < ActiveRecord::Base
  belongs_to :data_record

  has_attached_file :file, PAPERCLIP_CONFIG

  validate :presence_of_file_or_url
  validates_presence_of :format

  def download_url
    external_url.presence || file.url
  end

  private

  def presence_of_file_or_url
    errors.add_to_base("You need to either upload a file or provide an URL to the document.") if file_file_name.blank? && external_url.blank?
  end
end
