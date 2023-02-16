class Holiday < ApplicationRecord
  validates :name, presence: true
  validates :date_holiday, presence: true, uniqueness: true
end
