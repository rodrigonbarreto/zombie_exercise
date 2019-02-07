module Api
  module V1
    class ZombieSerializer < ActiveModel::Serializer
      attributes :id, :name, :hit_points, :brains_eaten, :speed, :turn_date

      has_many :weapons
      has_many :armors
    end
  end
end