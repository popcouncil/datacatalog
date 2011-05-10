desc "Imports data stored in the csv file"
task :import => :environment do
  require 'csv'
  admin = User.first(:conditions => {:email => 'admin@datauncovered.com'})
  continents = [1, 65, 156, 17, 152, 2, 119]
  i = 0
  CSV.foreach(RAILS_ROOT + '/lib/DDC20110429.csv') do |row|
    i+=1
    next if row[0] and row[0].include?('1')
    (title, desc, cov1, cov2, subnat, subnat2, lead, collaborators, leadurl, author1, affiliation1, author2, affiliation2, name, funder, year, tag1, tag2, tag3, huh, link_title, link_type, link, huh, huh, huh, contact_name, contact_phone, contact_email) = row[2..32].collect { |x| x.strip if x }
    puts "Line #{i}..."
    attributes = {:title => title, :description => desc, :year => year, :tag_list => [tag1, tag2, tag3].compact.join(','),
      :owner => admin, :lead_organization_name => lead, :collaborator_list => collaborators, :funder => funder,
      :homepage_url => leadurl,
      :contact_attributes => {:name => contact_name, :email => contact_email, :phone => contact_phone},
      :data_record_locations_attributes => {},
      :documents_attributes => {},
      :authors_attributes => {}}
    loc1 = Location.find_by_name(cov1)
    if !loc1.present?
      puts "No location found for #{title} at '#{cov1}'"
      next 
    end
    attributes[:data_record_locations_attributes] = {'0' => {:location_id => loc1.id}}
    unless continents.include?(loc1.id)
      attributes[:data_record_locations_attributes]['0'][:disaggregation_level] = subnat
    end
    unless cov2.blank?
      loc2 = Location.find_by_name(cov2)
      attributes[:data_record_locations_attributes] = {'1' => {:location_id => loc2.id}}
      attributes[:data_record_locations_attributes]['1'][:disaggregation_level] = subnat
    end
    attributes[:documents_attributes] = {'0' => {:title => link_title, :document_type => link_type, :external_url => link}} unless link_title.blank? or link_type.blank?
    attributes[:authors_attributes] = {'0' => {:name => author1, :affiliation_name => affiliation1}} unless author1.blank?
    attributes[:authors_attributes] = {'0' => {:name => author2, :affiliation_name => affiliation2}} unless author2.blank?
    d = DataRecord.new(attributes)
    d.completed = true
    if d.save
      puts "Success #{title}"
    else
      puts "Failure #{title} - #{d.errors.full_messages.inspect}"
    end
  end
end
