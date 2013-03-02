class Api::V1::BeerStylePresenter < ApiPresenter
  def initialize(beer_style)
    @beer_style = beer_style
  end

  def as_json
    { id:          @beer_style.id,
      name:        @beer_style.name,
      description: @beer_style.description,
      created_at:  @beer_style.created_at,
      updated_at:  @beer_style.updated_at
    }
  end
end
