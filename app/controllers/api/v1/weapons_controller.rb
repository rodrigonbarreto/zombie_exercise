module Api
  module V1
    class WeaponsController < ApplicationController
      before_action :set_api_v1_weapon, only: [:show]

      # GET /api/v1/weapons
      def index
        @weapons = Weapon.all
        render json: @weapons
      end

      # GET /api/v1/weapons/1
      def show
        render json: @weapon
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_api_v1_weapon
        @weapon = Weapon.find(params[:id])
      end
    end
  end
end
