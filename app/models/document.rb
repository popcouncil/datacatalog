class Document < ActiveRecord::Base
  DOCUMENT_TYPES = %w(Data Journal\ Article News\ Article Map Report Other)

  belongs_to :data_record

  has_attached_file :file, PAPERCLIP_CONFIG

  validate :presence_of_file_or_url
  validates_inclusion_of :document_type, :in => DOCUMENT_TYPES

  def download_url # Bug alert, XSS?
    if self.external?
      begin
        x = self.external_url.include?('://') ? self.external_url : "http://#{self.external_url}"
        uri = URI.parse(x)
        uri.to_s
      rescue
        '#'
      end
    else
      file.url
    end
  end

  def external?
    !self.external_url.blank?
  end

  def storage
    if @storage.present?
      @storage
    elsif external_url.present?
      "external"
    elsif file_file_name.present?
      "upload"
    end
  end

  def storage=(type)
    @storage = type
  end

  private

  def presence_of_file_or_url
    errors.add_to_base("You need to either upload a file or provide an URL to the document.") if file_file_name.blank? && external_url.blank?
  end
end
