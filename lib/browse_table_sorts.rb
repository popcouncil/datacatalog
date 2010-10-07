module BrowseTableSorts
  def self.included(controller)
    controller.class_eval do
      sortable_attributes :"lower(data_records.title)", :title        => "lower(data_records.title)",
                                                        :rating       => "data_records.ratings_total",
                                                        :location     => "lower(locations.name)",
                                                        :ministry     => "lower(users.name)",
                                                        :organization => "lower(organizations.name)",
                                                        :format       => "lower(documents.document_type)",
                                                        :tags         => "lower(tags.name)"
    end
  end
end
