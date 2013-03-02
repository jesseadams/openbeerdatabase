breweries = ['Haymarket Pub and Brewery', 'Three Floyds', 'Revolution Brewing']

created_breweries = []
breweries.each do |brewery|
  puts "Creating Brewery: #{brewery}"
  created_breweries << Brewery.create({:name => brewery})
end

puts "Creating Beer: Assailant Double IPA"
beer = Beer.new({
  :name => 'Assailant Double IPA',
  :description => 'The color of a sunset and aromas of citrus and tropical fruit. Dry-hopped with Centennial, Citra & Crystal hops.',
  :abv => 7.5,
})
beer.brewery = created_breweries.first
beer.save!
