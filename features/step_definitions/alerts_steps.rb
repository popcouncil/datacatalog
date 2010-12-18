Given /^an alert exists$/ do
  Alert.create(:user_id => User.first.id, :tag_id => Tag.first.id, :location_id => Location.find_by_name('Global'), :by_email => true)
end
