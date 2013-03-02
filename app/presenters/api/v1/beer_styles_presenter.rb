class Api::V1::BeerStylesPresenter < Api::V1::CollectionPresenter
  def klass
    Api::V1::BeerStylePresenter
  end

  def type
    :beer_styles
  end
end
