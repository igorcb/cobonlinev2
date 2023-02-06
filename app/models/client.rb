class Client < ActiveRecord::Base
  belongs_to :city
  has_many :advances
  validates :city_id, presence: true
  validates :name, presence: true
  validates :credit_limit, presence: true
  enum :status, [ :active, :inactive ], scopes: true

  scope :order_asc, -> { order(name: :asc) }
end
