module LocationsHelper
  def all_countries_for_select
    Location.countries.map {|c| [c.name, c.id.to_s] }.sort_by {|name, _| name }
  end

  def all_locations_for_select(*preferential)
    locations = []
    locations += preferential
    locations << [Location.global.name, Location.global.id.to_s]
    locations << "-------------"
    locations += Location.continents.map {|c| [c.name, c.id.to_s] }.sort_by {|name, _| name }
    locations << "-------------"
    locations += Location.countries.map {|c| [c.name, c.id.to_s] }.sort_by {|name, _| name }
    locations
  end
end
