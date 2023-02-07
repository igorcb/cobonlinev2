class Client < ActiveRecord::Base
  belongs_to :city
  belongs_to :type_trade
  has_many :advances
  validates :city_id, presence: true
  validates :name, presence: true
  validates :type_payment, presence: true
  validates :credit_limit, presence: true
  enum :status, [ :active, :inactive ], scopes: true
  enum :type_payment, [ :daily, :fortnightly, :monthly], scopes: true
  # enum :type_payment, { daily: 0, fortnightly: 1, monthly: 2 }, scopes: true

  scope :order_asc, -> { order(name: :asc) }
end
