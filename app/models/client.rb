class Client < ApplicationRecord
  belongs_to :city
  belongs_to :type_trade
  has_many :advances
  validates :name, presence: true
  validates :type_payment, presence: true
  validates :credit_limit, presence: true
  enum :status, %i[active inactive], scopes: true
  enum :type_payment, %i[daily fortnightly monthly], scopes: true
  # enum :type_payment, { daily: 0, fortnightly: 1, monthly: 2 }, scopes: true

  scope :order_asc, -> { order(name: :asc) }
end
