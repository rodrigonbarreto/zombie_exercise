FactoryBot.define do
  factory :zombie, aliases: [:xx] do
    transient do
      number_of_armors 3
      number_of_weapons 5
    end

    name { "#{Faker::Superhero.prefix} #{Faker::TvShows::RickAndMorty.character}" }
    hit_points { Faker::Number.between(1, 10) }
    speed { Faker::Number.between(1, 10) }
    brains_eaten { Faker::Number.between(1, 50) }
    turn_date { Faker::Date.between(2.years.ago, Date.today) }

    trait :with_armors do
      after(:create) do |zombie, evaluator|
        armor = create(:armor)
        create_list(:zombie_armor, evaluator.number_of_armors, zombie: zombie, armor: armor)
      end
    end

    trait :with_weapons do
      after(:create) do |zombie, evaluator|
        weapon = create(:weapon)
        create_list(:zombie_weapon, evaluator.number_of_weapons, zombie: zombie, weapon: weapon)
      end
    end
    factory :zombie_with_armors, traits: [:with_armors]
    factory :zombie_with_weapons, traits: [:with_weapons]
    factory :zombie_with_weapons_and_armors, traits: [:with_weapons, :with_armors]
  end
end
