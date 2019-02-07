module Api
  module V1
    class ArmorsController < ApplicationController
      before_action :set_api_v1_armor, only: [:show]

      # GET /api/v1/armors
      def index
        @armors = Armor.all
        render json: @armors
      end

      # GET /api/v1/armors/1
      def show
        render json: @armor
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_api_v1_armor
        @armor = Armor.find(params[:id])
      end
    end
  end
end
