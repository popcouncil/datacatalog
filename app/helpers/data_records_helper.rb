module DataRecordsHelper
  def years_for_select
    ["All", "-------------"] + DataRecord.available_years
  end
end
