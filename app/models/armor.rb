class Armor < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :defense_points, :durability, :price, numericality: { only_integer: true }, allow_nil: true

  has_many :zombie_armors
  has_many :zombies, through: :zombie_armors

  before_validation_remove_white_spaces_for :name
end
