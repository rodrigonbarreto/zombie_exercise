class Zombie < ApplicationRecord

  include SearchCop

  search_scope :full_search do
    attributes :name, :hit_points, :brains_eaten, :speed
    attributes armor: "armors.name"
    attributes weapon: "weapons.name"
  end

  # kaminari
  paginates_per 5

  validates :name, presence: true, length: { maximum: 255 }
  validates :hit_points, :brains_eaten, :speed, numericality: { only_integer: true }, allow_nil: true
  validates :hit_points, :speed, presence: true, numericality: { only_integer: true }
  validates :brains_eaten, numericality: { only_integer: true }, allow_nil: true

  has_many :zombie_armors
  has_many :armors, through: :zombie_armors, dependent: :destroy
  accepts_nested_attributes_for :armors, reject_if: :all_blank, allow_destroy: true

  has_many :zombie_weapons
  has_many :weapons, through: :zombie_weapons, dependent: :destroy
  accepts_nested_attributes_for :weapons, reject_if: :all_blank, allow_destroy: true

  before_validation_remove_white_spaces_for :name
end
