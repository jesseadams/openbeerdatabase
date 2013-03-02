class BeerStyle < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(id name created_at updated_at).freeze

  include SearchableModel
  include BeerAssociation

  has_many :beers
  belongs_to :user

  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 4096 }

  attr_accessible :name, :description

  before_destroy :ensure_no_associated_beers_exist

  def self.search(options = {})
    for_token(options[:token])
      .filter_by_name(options[:query])
      .page(options[:page])
      .per_page(options[:per_page] || 50)
      .order_by(options[:order])
  end

  def public?
    user_id.nil?
  end
end
