require 'rails_helper'

RSpec.describe ZombieWeapon, type: :model do

  it 'zombie_weapon without weapon' do
    zombie_weapon = build(:zombie_weapon, weapon: nil)
    expect(zombie_weapon.valid?).to eq(false)
    errors = zombie_weapon.errors.full_messages
    expect(errors[0]).to eq("Weapon must exist")
  end

  it 'zombie_weapon without zombie' do
    zombie_weapon = build(:zombie_armor, zombie: nil)
    expect(zombie_weapon.valid?).to eq(false)
    errors = zombie_weapon.errors.full_messages
    expect(errors[0]).to eq("Zombie must exist")
  end

  it 'zombie_weapon with weapon and zombie!' do
    zombie = build(:zombie_armor)
    expect(zombie.valid?).to eq(true)
    expect(zombie.save!).to eq(true)
  end

end
