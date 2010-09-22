module OrganizationsHelper
  def organization_tree_except(org)
    nested_set_options(Organization, org) {|i| "#{'-' * i.level} #{i.name}" }
  end

  def organizations_for_select(list)
    list.map {|org| [org.name, org.id] }
  end

  def organizations_for_filtering
    ["All", "-------------"] + organization_tree_except(nil).map do |name, id|
      [name, id.to_s]
    end
  end
end
