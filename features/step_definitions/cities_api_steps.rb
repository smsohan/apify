Given /^the following cities:$/ do |cities|
  City.create(:name => 'Dhaka', :country => 'Bangladesh')
  City.create(:name => 'Calagry', :country => 'Canada')  
end

When /^I delete the (\d+)(?:st|nd|rd|th) cities_api$/ do |pos|
  visit cities_apis_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following cities_apis:$/ do |expected_cities_apis_table|
  expected_cities_apis_table.diff!(tableish('table tr', 'td,th'))
end
