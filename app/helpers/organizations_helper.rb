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

  def organizations_for(data_record)
    data_record.sponsors.sort_by do |sponsor|
      sponsor.organization.name.downcase
    end.map do |sponsor|
      if sponsor.lead?
        [content_tag(:strong, sponsor.organization.name), sponsor.organization]
      else
        [sponsor.organization.name, sponsor.organization]
      end
    end.map do |name, org|
      link_to name, org
    end.join(", ")
  end
end
