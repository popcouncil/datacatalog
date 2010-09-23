module DataRecordsHelper
  def years_for_select
    ["All", "-------------"] + DataRecord.available_years
  end

  def linked_tags(record)
    record.tags.map { |tag| link_to tag, data_records_path(:filters => { :tags => tag.name }) }.join(", ")
  end
end
