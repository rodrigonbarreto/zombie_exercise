module Api
  module V1
    class ArmorSerializer < ActiveModel::Serializer
      attributes :id, :name, :defense_points, :durability, :price
    end
  end
end