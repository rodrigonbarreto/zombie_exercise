FactoryBot.define do
  factory :armor do
    ARMOR_SUFFIXES = %w(armor helmet shield).freeze

    name { "#{Faker::Food.ingredient} #{ARMOR_SUFFIXES.sample}".capitalize }
    defense_points { Faker::Number.between(1, 10) }
    durability { Faker::Number.between(1, 10) }
    price { Faker::Number.between(1, 50) }
  end
end