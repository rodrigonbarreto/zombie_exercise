require 'rails_helper'

RSpec.describe Zombie, type: :model do

  it 'zombie without name' do
    zombie = build(:zombie, name: nil)
    expect(zombie.valid?).to eq(false)
    errors = zombie.errors.full_messages
    expect(errors[0]).to eq("Name can't be blank")
  end

  # Sometimes users are like zombies and make our life HARD
  # One of the thing they really really REALLY like is create USERS with spaces.
  it 'zombie without double or extra spaces on name in database' do
    zombie = build(:zombie, name: ' frankie              stein   ')
    expect(zombie.valid?).to eq(true)

    expect(zombie.name).to eq('frankie stein')
  end

  it 'Name is too big' do
    zombie = build(:zombie, name: Faker::Lorem.characters(300))
    expect(zombie.valid?).to eq(false)
    errors = zombie.errors.full_messages
    expect(errors[0]).to eq("Name is too long (maximum is 255 characters)")
  end

  it 'hit_points and speed error msg' do
    zombie = build(:zombie, name: 'ZombieX', speed: '', hit_points: '')
    expect(zombie.valid?).to eq(false)
    errors = zombie.errors.full_messages

    expect(errors[0]).to eq("Hit points can't be blank")
    expect(errors[1]).to eq("Hit points is not a number")
    expect(errors[2]).to eq("Speed can't be blank")
    expect(errors[3]).to eq("Speed is not a number")
  end

  it 'valid zombie with name and < 255' do
    zombie = build(:zombie)
    expect(zombie.valid?).to eq(true)
    expect(zombie.save).to eq(true)
  end

  it 'check basic factory to create a zombie ' do
    zombie = create(:zombie)
    expect(zombie.name).to eq(zombie.name)
  end

  it 'chicken zombie has 10 armors' do
    zombie = create(:zombie_with_armors, number_of_armors: 10)
    expect(zombie.armors.size).to eq(10)
  end

  it 'Brave zombie has 5 weapons' do
    zombie = create(:zombie_with_weapons, number_of_weapons: 5)
    expect(zombie.weapons.size).to eq(5)
  end

  it 'RAMBO zombie  has 3 weapons and 3 armors' do
    zombie = create(:zombie_with_weapons_and_armors)
    expect(zombie.weapons.size).to eq(5)
    expect(zombie.armors.size).to eq(3)
  end
end
