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
      author.affiliation.present? ?  "#{author.name} (#{author.affiliation.name})" : author.name
    end.join(", ")
  end

  def topic_tags
    @topic_tags_ ||= Tag.all(:conditions => {:kind => 'topics'}).collect { |i| [i.name] }
    @topic_tags ||= ['Select Tag', '-------------'] + [['All', @topic_tags_.join(',')]] + @topic_tags_
  end
end
