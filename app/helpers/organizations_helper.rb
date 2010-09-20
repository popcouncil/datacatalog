module OrganizationsHelper
  def organization_tree_except(org)
    nested_set_options(Organization, org) {|i| "#{'-' * i.level} #{i.name}" }
  end
end
