module DataRecordsHelper
  def years_for_select
    ["All", "-------------"] + DataRecord.available_years
  end
  
  def document_types_for_select
    ["All", "-------------"] + Document::DOCUMENT_TYPES
  end

  def linked_tags(record)
    record.tags.map { |tag| link_to tag, data_records_path(:filters => { :tags => tag.name }) }.join(", ")
  end

  def authors_of(record)
    record.authors.map do |author|
      author.affiliation.present? ?  "#{author.name} (#{link_to author.affiliation.name, author.affiliation})" : author.name
    end.join(", ")
  end
end
