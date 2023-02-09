FactoryBot.define do
  factory :advance do
    client
    date_advance { Date.today }
    price { 1000 }
    percent { 15 }
    number_parts { 20 }
  end
end