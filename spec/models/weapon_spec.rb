require 'rails_helper'

RSpec.describe Weapon, type: :model do
  it 'weapon without name' do
    weapon = build(:weapon, name: nil)
    expect(weapon.valid?).to eq(false)
    errors = weapon.errors.full_messages
    expect(errors[0]).to eq("Name can't be blank")
  end

  it 'Name is too big' do
    weapon = build(:weapon, name: Faker::Lorem.characters(300))
    expect(weapon.valid?).to eq(false)
    errors = weapon.errors.full_messages
    expect(errors[0]).to eq("Name is too long (maximum is 255 characters)")
  end
  it 'valid  weapon with name and < 255' do
    weapon = build(:weapon)
    expect(weapon.valid?).to eq(true)
    expect(weapon.save).to eq(true)
  end
end
