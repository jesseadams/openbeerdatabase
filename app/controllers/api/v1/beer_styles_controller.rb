class Api::V1::BeerStylesController < Api::V1::BaseController
  def index
    breweries = BeerStyle.search(params)

    render json: Api::V1::BeerStylesPresenter.new(breweries)
  end

  def show
    beer_style = BeerStyle.find(params[:id])

    if params[:token].present?
      return head(:unauthorized) unless authorized_for?(beer_style)
    end

    render json: Api::V1::BeerStylePresenter.new(beer_style)
  end

  def create
    beer_style = current_user.beer_styles.build(params[:beer_style])

    if beer_style.save
      head :created, location: v1_beer_style_url(beer_style, format: :json)
    else
      render json:   { errors: beer_style.errors },
             status: :bad_request
    end
  end

  def update
    beer_style = BeerStyle.find(params[:id])

    if authorized_for?(beer_style)
      if beer_style.update_attributes(params[:beer_style])
        head :ok
      else
        render json:   { errors: beer_style.errors },
               status: :bad_request
      end
    else
      head :unauthorized
    end
  end

  def destroy
    beer_style = BeerStyle.find(params[:id])

    if authorized_for?(beer_style)
      if beer_style.destroy
        head :ok
      else
        head :bad_request
      end
    else
      head :unauthorized
    end
  end
end
