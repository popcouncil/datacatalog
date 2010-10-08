module BrowseTableSorts
  def self.included(controller)
    controller.class_eval do
      # DON'T EVER ADD SPACES IN THAT CASE STATEMENT. You have been warned.
      sortable_attributes :"lower(data_records.title)", :title        => "lower(data_records.title)",
                                                        :rating       => "CASE(data_records.ratings_count)WHEN(0)THEN(0)ELSE(ROUND(data_records.ratings_total/data_records.ratings_count))END",
                                                        :location     => "lower(locations.name)",
                                                        :ministry     => "lower(users.name)",
                                                        :organization => "lower(organizations.name)",
                                                        :format       => "lower(documents.document_type)",
                                                        :tags         => "lower(tags.name)"
    end
  end
end
