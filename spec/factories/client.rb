FactoryBot.define do
  factory :client do
    city
    type_trade
    name { Faker::Name.name }
  end
end