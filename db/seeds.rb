breweries = ['Haymarket Pub and Brewery', 'Three Floyds', 'Revolution Brewing']

created_breweries = []
breweries.each do |brewery|
  puts "Creating Brewery: {brewery}"
  created_breweries << Brewery.create({:name => brewery})
end

puts "Creating Beer Style: American Imperial / Double IPA"
beer_style = BeerStyle.create({
  :name => 'American Imperial / Double IPA',
  :description => 'Take an India Pale Ale and feed it steroids, ergo the term Double IPA. Although open to the same interpretation as its sister styles, you should expect something robust, malty, alcoholic and with a hop profile that might rip your tongue out. The Imperial usage comes from Russian Imperial stout, a style of strong stout originally brewed in England for the Russian Imperial Court of the late 1700s; though Double IPA is often the preferred name.'
})

puts "Creating Beer: Assailant Double IPA"
beer = Beer.new({
  :name => 'Assailant Double IPA',
  :description => 'The color of a sunset and aromas of citrus and tropical fruit. Dry-hopped with Centennial, Citra & Crystal hops.',
  :abv => 7.5,
})
beer.brewery = created_breweries.first
beer.beer_style = beer_style
beer.save!

puts "Creating User: Developer"
user = User.create({
  :name => 'Developer',
  :email => 'developer@example.com',
  :password => 'pass123word',
  :password_confirmation => 'pass123word',
})
user.update_attribute(:administrator, true)

puts "Password: pass123word"
puts "Public Token: #{user.public_token}"
puts "Private Token: #{user.private_token}"
