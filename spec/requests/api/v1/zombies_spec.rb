# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Zombies', type: :request do
  describe 'GET /api/v1/zombies' do
    setup do
      @frank = create(:zombie_with_weapons_and_armors, number_of_armors: 1, number_of_weapons: 1, name: 'Frankenstein')
      create_list(:zombie, 3)
      create_list(:armor, 5)
      create_list(:weapon, 5)
      @frank.armors << create(:armor, name: 'helmet')
      @frank.weapons << create(:weapon, name: 'fork')
      @headers = { 'ACCEPT' => 'application/json' }
    end

    describe '#index' do
      context 'get all zombies' do
        it 'responds with 200' do
          get api_v1_zombies_path
          expect(response).to have_http_status(200)
        end
      end

      context 'search by name' do
        it 'responds with 200 and get zombie by name' do
          get api_v1_zombies_path, params: { search: 'Frankenstein' }
          expect(response).to have_http_status(200)
          expect(response.body).to include_json([name: 'Frankenstein'])
        end
      end

      context 'search by weapon' do
        it 'responds with 200 and get zombie by weapon' do
          get api_v1_zombies_path, params: { search: 'fork' }
          expect(response).to have_http_status(200)
          expect(response.body).to include_json([name: 'Frankenstein'])
        end
      end

      context 'search by armor' do
        it 'responds with 200 and get zombie by armor' do
          get api_v1_zombies_path, params: { search: 'helmet' }
          expect(response).to have_http_status(200)
          expect(response.body).to include_json([name: 'Frankenstein'])
        end
      end

      context 'check JSON type fields' do
        it 'Json response type fields' do
          get api_v1_zombies_path
          expect(response.body).to include_json([
                                                  id: /\d/,
                                                  name: (be_kind_of String),
                                                  hit_points: (be_kind_of Integer),
                                                  brains_eaten: (be_kind_of Integer),
                                                  speed: (be_kind_of Integer),
                                                  armors: (be_kind_of Array),
                                                  weapons: (be_kind_of Array)
                                                ])
        end
      end
    end
    describe '#show' do
      context 'show action' do
        it 'return 200 and check fields' do
          get api_v1_zombie_path(@frank)
          expect(response.body).to include_json(
            id: @frank.id,
            name: @frank.name,
            hit_points: @frank.hit_points,
            brains_eaten: @frank.brains_eaten,
            speed: @frank.speed
          )
          expect(response).to have_http_status(200)
        end
      end
    end

    describe '#create' do
      context 'create a not valid zombie' do
        it 'invalid zombie' do
          zombie_params = { name: '', hit_points: '', speed: '' }
          post api_v1_zombies_path, params: { zombie: zombie_params }, headers: @headers
          expect(response.body).to include_json(errors:
          [
            { id: 'name', title: "can't be blank" },
            { id: 'hit_points', title: "can't be blank" },
            { id: 'hit_points', title: 'is not a number' },
            { id: 'speed', title: "can't be blank" },
            { id: 'speed', title: 'is not a number' }
          ])
        end
      end
      context 'create a valid zombie' do
        it 'valid zombie ' do
          zombie_params = attributes_for(:zombie)
          post api_v1_zombies_path, params: { zombie: zombie_params }, headers: @headers

          expect(response.body).to include_json(id: /\d/,
                                                name: zombie_params.fetch(:name),
                                                hit_points: zombie_params.fetch(:hit_points),
                                                speed: zombie_params.fetch(:speed),
                                                brains_eaten: zombie_params.fetch(:brains_eaten))
        end

        it 'create a strong zombie with weapon and armor' do
          zombie_params = attributes_for(:zombie)
          zombie_params[:weapons_attributes] = [attributes_for(:weapon)]
          zombie_params[:armors_attributes] = [attributes_for(:weapon)]

          post api_v1_zombies_path, params: { zombie: zombie_params }, headers: @headers

          expect(response.body).to include_json(id: /\d/,
                                                name: zombie_params.fetch(:name),
                                                hit_points: zombie_params.fetch(:hit_points),
                                                speed: zombie_params.fetch(:speed),
                                                brains_eaten: zombie_params.fetch(:brains_eaten))

          expect(JSON.parse(response.body)['armors'].first).to have_key('name')
          expect(JSON.parse(response.body)['weapons'].first).to have_key('name')
          expect(JSON.parse(response.body)['armors'].size).to eq(1)
          expect(JSON.parse(response.body)['weapons'].size).to eq(1)
        end

        it 'add weapons and armor to a new zombie' do
          zombie_params = attributes_for(:zombie)
          zombie_params[:armor_ids] = Armor.limit(2).pluck(:id)
          zombie_params[:weapon_ids] = Weapon.limit(2).pluck(:id)

          post api_v1_zombies_path, params: { zombie: zombie_params }, headers: @headers

          expect(response.body).to include_json(id: /\d/,
                                                name: zombie_params.fetch(:name),
                                                hit_points: zombie_params.fetch(:hit_points),
                                                speed: zombie_params.fetch(:speed),
                                                brains_eaten: zombie_params.fetch(:brains_eaten))

          expect(JSON.parse(response.body)['armors'].first).to have_key('name')
          expect(JSON.parse(response.body)['weapons'].first).to have_key('name')
          expect(JSON.parse(response.body)['armors'].size).to eq(2)
          expect(JSON.parse(response.body)['weapons'].size).to eq(2)
        end
      end
    end

    describe '#update' do
      it 'update a strong zombie with weapon and armor' do
        @frank.name += '- UPDATED'
        patch api_v1_zombie_path(@frank), params: { zombie: @frank.attributes }, headers: @headers
        expect(response.body).to include_json(id: @frank.id, name: @frank.name, hit_points: @frank.hit_points)
      end

      it 'update - remove armor and weapon' do
        frank = @frank.armors.first.attributes
        frank[:armors_attributes] = @frank.armors.first.attributes
        frank[:armors_attributes]['_destroy'] = true
        frank[:weapons_attributes] = @frank.weapons.first.attributes
        frank[:weapons_attributes]['_destroy'] = true

        expect(@frank.armors.size).to eq(2)
        expect(@frank.weapons.size).to eq(2)
        patch api_v1_zombie_path(@frank), params: { zombie: frank }, headers: @headers

        expect(@frank.armors.size).to eq(1)
        expect(@frank.weapons.size).to eq(1)
      end
    end
    describe '#destroy' do
      context 'destroy - Bye Bye Frank :( ' do
        it 'return 204 ' do
          expect { delete api_v1_zombie_path(@frank), headers: headers }.to change(Zombie, :count).by(-1)
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
