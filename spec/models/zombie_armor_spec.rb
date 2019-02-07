require 'rails_helper'

RSpec.describe ZombieArmor, type: :model do
  it 'zombie_armor without armor' do
    zombie_armor = build(:zombie_armor, armor: nil)
    expect(zombie_armor.valid?).to eq(false)
    errors = zombie_armor.errors.full_messages
    expect(errors[0]).to eq("Armor must exist")
  end

  it 'zombie_armor without zombie' do
    zombie_armor = build(:zombie_armor, zombie: nil)
    expect(zombie_armor.valid?).to eq(false)
    errors = zombie_armor.errors.full_messages
    expect(errors[0]).to eq("Zombie must exist")
  end

  it 'zombie_armor with zombie and armor!' do
    zombie_armor = build(:zombie_armor)
    expect(zombie_armor.valid?).to eq(true)
    expect(zombie_armor.save!).to eq(true)
  end
end
