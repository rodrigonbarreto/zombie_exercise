class Weapon < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :attack_points, :durability, :price, numericality: { only_integer: true }, allow_nil: true

  has_many :zombie_weapons
  has_many :zombies, through: :zombie_weapons

  scope :search_by_name, ->(param) { where("weapons.name LIKE ?", "%#{param}%") }

  before_validation_remove_white_spaces_for :name
end
