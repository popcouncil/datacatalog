module LocationsHelper
  def all_countries_for_select(blank = false)
    locations = Location.countries.map {|c| [c.name, c.id] }.sort_by {|name, _| name }
    locations = ['Select Country', ''] + locations if blank
    locations
  end

  def all_locations_for_select(*preferential)
    options = preferential.extract_options!
    options.reverse_merge!(:stringify_ids => true)

    get_id = lambda do |obj|
      if options[:stringify_ids]
        obj.id.to_s
      else
        obj.id
      end
    end

    locations = []
    locations += preferential
    locations << [Location.global.name, get_id[Location.global]]
    locations << "-------------"
    locations += Location.continents.map {|c| [c.name, get_id[c]] }.sort_by {|name, _| name }
    locations << "-------------"
    locations += Location.countries.map {|c| [c.name, get_id[c]] }.sort_by {|name, _| name }
    locations
  end
  
  def disaggregation_levels_for_select
    dls = DataRecordLocation::DISAGGREGATION_LEVELS.dup
    dls.insert(0, "UNKNOWN", "-------------")
    dls.insert(5, "-------------")
    dls
  end
end
