API_HOST = "api.openbeerdatabase.local"

# Request

When /^I send an API GET request to (.*)$/ do |path|
  get "http://#{API_HOST}#{path}"
end

When /^I send an API POST request to (.*)$/ do |path, body|
  post "http://#{API_HOST}#{path}", body, { "CONTENT_TYPE" => "application/json" }
end

When /^I send an API PUT request to (.*)$/ do |path, *body|
  put "http://#{API_HOST}#{path}", body.first, { "CONTENT_TYPE" => "application/json" }
end

When /^I send an API DELETE request to (.*)$/ do |path|
  delete "http://#{API_HOST}#{path}"
end


# Response

Then /^I should receive a (\d+) response$/ do |status|
  last_response.status.should == status
end

Then /^the Location header should be set to (.+)$/ do |page_name|
  location = case page_name
             when /^the API beer page for "([^"]+)"$/
               beer = Beer.find_by_name!($1)
               v1_beer_url(beer, format: :json, host: API_HOST)
             when /^the API brewery page for "([^"]+)"$/
               brewery = Brewery.find_by_name!($1)
               v1_brewery_url(brewery, format: :json, host: API_HOST)
             end

  last_response.headers["Location"].should == location
end

Then /^I should see the following JSON response:$/ do |expected_json|
  require "json"
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(last_response.body))
  expected.should == actual
end

Then /^I should see the following JSONP response with an? "([^"]*)" callback:$/ do |callback, expected_json|
  require "json"
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(last_response.body.match(/^#{callback}\((.+)\)$/)[1]))
  expected.should == actual
end


# Beer

When /^I create the following "([^"]*)" style beers? via the API for the "([^"]*)" brewery using the "([^"]*)" token:$/ do |beer_style_name, brewery_name, token, table|
  brewery = Brewery.find_by_name!(brewery_name)
  beer_style = BeerStyle.find_by_name!(beer_style_name)

  table.hashes.each do |hash|
    json = {
        beer_style_id: beer_style.id,
        brewery_id:    brewery.id,
        beer:          hash
    }.to_json

    step %{I send an API POST request to /v1/beers.json?token=#{token}}, json
  end
end

When /^I update the "([^"]*)" beer via the API using the "([^"]*)" token:$/ do |name, token, table|
  beer = Beer.find_by_name!(name)

  table.hashes.each do |hash|
    step %{I send an API PUT request to /v1/beers/#{beer.id}.json?token=#{token}}, { beer: hash }.to_json
  end
end


# Brewery

When /^I create the following (?:brewery|breweries) via the API using the "([^"]*)" token:$/ do |token, table|
  table.hashes.each do |hash|
    step %{I send an API POST request to /v1/breweries.json?token=#{token}}, { brewery: hash }.to_json
  end
end

When /^I update the "([^"]*)" brewery via the API using the "([^"]*)" token:$/ do |name, token, table|
  brewery = Brewery.find_by_name!(name)

  table.hashes.each do |hash|
    step %{I send an API PUT request to /v1/breweries/#{brewery.id}.json?token=#{token}}, { brewery: hash }.to_json
  end
end
