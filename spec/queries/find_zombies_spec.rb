# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindZiombies do
  setup do
    create_list(:armor, 10)
    create_list(:weapon, 10)
    create(:zombie, name: 'frankenstein', speed: 300)
    create(:zombie, name: 'frank sinatra', brains_eaten: 101)
    create(:zombie, name: 'frank', hit_points: 110)
    create(:armor, name: 'helmet')
    create(:armor, name: 'shield')
    create(:weapon, name: 'molotov')
    create(:weapon, name: 'shotgun')
    @zombie = Zombie.last
    @zombie.armors << Armor.where(name: %w[helmet shield])
    @zombie.weapons << Weapon.where(name: %w[molotov shotgun])
    @initial_scope = Zombie.all
  end

  describe 'FindZombies without params' do
    subject { described_class.new(@initial_scope).call({}) }
    it 'returns all zombies' do
      create_list(:zombie_with_weapons_and_armors, 10, number_of_armors: 1, number_of_weapons: 1, name: 'Frankenstein')
      expect(subject.to_sql).to include('SELECT `zombies`.* FROM `zombies`')
      expect(subject.size).to eq(13)
    end
  end

  describe 'FindZombies by armor with generic search - armor' do
    subject { described_class.new(@initial_scope).call(search: 'helmet') }
    it 'search by armor' do
      expect(subject.map(&:name)).to match_array([@zombie.name.to_s])
    end
  end

  describe 'FindZombies by armor with generic search - weapon' do
    subject { described_class.new(@initial_scope).call(search: 'molotov') }
    it 'search by weapon' do
      expect(subject.map(&:name)).to match_array([@zombie.name.to_s])
    end
  end

  describe 'FindZombies with param search_zombie_name' do
    subject { described_class.new(@initial_scope).call(search: 'frank') }
    it 'search by search_zombie_name ' do
      expect(subject.to_sql).not_to include("zombies.brains_eaten LIKE '%frank%'")
      expect(subject.to_sql).not_to include("zombies.hit_points LIKE '%frank%'")
      expect(subject.size).to eq(3)
      expect(subject.map(&:name)).to match_array(%w[frankenstein frank\ sinatra frank])
    end
  end

  describe 'FindZombies with param search_zombie_hit_points' do
    subject { described_class.new(@initial_scope).call(search: '110') }
    it 'search by search_zombie_hit_points ' do
      expect(subject.size).to eq(1)
      expect(subject.map(&:name)).to match_array(%w[frank])
    end
  end

  describe 'FindZombies with param search_zombie_brains_eaten' do
    subject { described_class.new(@initial_scope).call(search: '101') }
    it 'search by search_zombie_brains_eaten' do
      expect(subject.size).to eq(1)
      expect(subject.map(&:name)).to match_array(%w[frank\ sinatra])
    end
  end

  describe 'FindZombies with param search_zombie_speed' do
    subject { described_class.new(@initial_scope).call(search: '300') }
    it 'search by search_zombie_speed ' do
      expect(subject.size).to eq(1)
      expect(subject.map(&:name)).to match_array(%w[frankenstein])
    end
  end

  describe 'Filter by armor' do
    subject { described_class.new(@initial_scope).call(armor_id: Armor.where(name: %w[helmet shield]).pluck(:id)) }
    it 'filter by armor id ' do
      expect(subject.size).to eq(1)
      expect(subject.map(&:name)).to match_array([@zombie.name.to_s])
    end
  end

  describe 'Filter by weapon' do
    subject { described_class.new(@initial_scope).call(weapon_id: Weapon.where(name: %w[molotov shotgun]).pluck(:id)) }
    it 'filter by weapon id ' do
      expect(subject.size).to eq(1)
      expect(subject.map(&:name)).to match_array([@zombie.name.to_s])
    end
  end
end
