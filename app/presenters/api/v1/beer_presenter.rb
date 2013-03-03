class Api::V1::BeerPresenter < ApiPresenter
  def initialize(beer)
    @beer = beer
  end

  def as_json
    { id:          @beer.id,
      name:        @beer.name,
      description: @beer.description,
      abv:         @beer.abv,
      created_at:  @beer.created_at,
      updated_at:  @beer.updated_at,
      brewery:     {
        id:   @beer.brewery.id,
        name: @beer.brewery.name
      },
      beer_style: beer_style_fields
    }
  end

  def beer_style_fields
    if @beer.beer_style.nil?
      {}
    else
      {
        id:   @beer.beer_style.id,
        name: @beer.beer_style.name
      }
    end
  end
end
