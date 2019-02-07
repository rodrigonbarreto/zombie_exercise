require 'rails_helper'

RSpec.describe Armor, type: :model do
  it 'armor without name' do
    armor = build(:armor, name: nil)
    expect(armor.valid?).to eq(false)
    errors = armor.errors.full_messages
    expect(errors[0]).to eq("Name can't be blank")
  end

  it 'Name is too big' do
    armor = build(:armor, name: Faker::Lorem.characters(300))
    expect(armor.valid?).to eq(false)
    errors = armor.errors.full_messages
    expect(errors[0]).to eq("Name is too long (maximum is 255 characters)")
  end
  it 'valid  armor with name and < 255' do
    armor = build(:armor)
    expect(armor.valid?).to eq(true)
    expect(armor.save).to eq(true)
  end
end
