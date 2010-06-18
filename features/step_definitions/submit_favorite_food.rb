Given /^I have a budget with "([^\"]*)" dollars left$/ do |dollars|
  Factory.create(:budget, :original_amount => dollars.to_i)
end