class TypeTrade < ApplicationRecord
  has_many :clients, dependent: :delete_all

  validates :name, presence: true, uniqueness: true
end
 