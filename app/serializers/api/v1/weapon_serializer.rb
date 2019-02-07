module Api
  module V1
    class WeaponSerializer < ActiveModel::Serializer
      attributes :id, :name, :attack_points, :durability, :price
    end
  end
end