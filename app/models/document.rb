class Document < ActiveRecord::Base
  belongs_to :data_record

  has_attached_file :file

  validate :presence_of_file_or_url

  private

  def presence_of_file_or_url
    errors.add_to_base("You need to either upload a file or provide an URL to the document.") if file_file_name.blank? && external_url.blank?
  end
end
