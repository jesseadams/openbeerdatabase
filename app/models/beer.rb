class Beer < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(id name created_at updated_at).freeze

  include SearchableModel

  belongs_to :brewery
  belongs_to :user
  belongs_to :beer_style

  validates :brewery_id,     presence: true
  validates :beer_style_id,  presence: true
  validates :name,           presence: true, length: { maximum: 255 }
  validates :description,    presence: true, length: { maximum: 4096 }
  validates :abv,            presence: true, numericality: true

  attr_accessible :name, :description, :abv

  def self.filter_by_brewery_id(brewery_id)
    if brewery_id.present?
      where(brewery_id: brewery_id)
    else
      where("")
    end
  end

  def self.filter_by_beer_style_id(beer_style_id)
    if beer_style_id.present?
      where(beer_style_id: beer_style_id)
    else
      where("")
    end
  end

  def self.search(options = {})
    includes(:brewery)
      .includes(:beer_style)
      .for_token(options[:token])
      .filter_by_name(options[:query])
      .filter_by_brewery_id(options[:brewery_id])
      .filter_by_beer_style_id(options[:beer_style_id])
      .page(options[:page])
      .per_page(options[:per_page] || 50)
      .order_by(options[:order])
  end

  def public?
    user_id.nil?
  end
end
