module Api
  module V1
    class ZombiesController < ApplicationController
      include ErrorSerializer
      before_action :set_api_v1_zombie, only: %i[show update destroy]

      # GET /api/v1/zombies
      def index
        @zombies = search_zombies(params).includes(:armors, :weapons).page(params[:page] || 1)
        paginate json: @zombies
      end

      # GET /api/v1/zombies/1
      def show
        render json: @zombie
      end

      # POST /api/v1/zombies
      def create
        @zombie = Zombie.new(api_v1_zombie_params)

        if @zombie.save
          render json: @zombie, status: :created
        else
          render json: ErrorSerializer.serialize(@zombie.errors), status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/zombies/1
      def update
        if @zombie.update(api_v1_zombie_params)
          render json: @zombie
        else
          render json: ErrorSerializer.serialize(@zombie.errors), status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/zombies/1
      def destroy
        @zombie.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_api_v1_zombie
        @zombie = Zombie.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      # note: in that case I can use armors_attributes: [:id] too. but I chose to use model_ids:
      def api_v1_zombie_params
        params.require(:zombie).permit(
          :name, :hit_points, :brains_eaten, :speed,
          weapons_attributes: action_name == 'create' ? %i[id name _destroy] : %i[id _destroy],
          armors_attributes: action_name == 'create' ? %i[id name _destroy] : %i[id _destroy],
          armor_ids: [],
          weapon_ids: []
        )
      end

      def search_zombies(params)
        FindZiombies.new(Zombie.all).call(params)
      end
    end
  end
end
