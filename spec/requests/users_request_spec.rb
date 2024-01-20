# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  context 'without custom fields' do
    describe 'GET /users' do
      before do
        create(:user, email: 'test1@test.com')
        create(:user, email: 'test2@test.com')
        create(:user, email: 'test3@test.com')

        get '/users'
      end

      it 'returns correct status' do
        expect(response.status).to eq 200
      end

      it 'returns correct data' do
        expect(parsed_response[:data].count).to eq 3
        expect(parsed_response.dig(:data, 0, :email)).to eq 'test1@test.com'
        expect(parsed_response.dig(:data, 1, :email)).to eq 'test2@test.com'
        expect(parsed_response.dig(:data, 2, :email)).to eq 'test3@test.com'
      end
    end

    describe 'POST /users' do
      context 'with valid attributes' do
        let(:user_email) { 'new-test@test.com' }

        before do
          post '/users', params: {
            user: {
              email: user_email
            }
          }
        end

        it 'returns status created' do
          expect(response.status).to eq 201
        end

        it 'returns correct values' do
          expect(parsed_response.dig(:data, :email)).to eq user_email
        end
      end

      context 'with not valid attributes' do
        before do
          post '/users', params: {
            user: {
              test: 'test'
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Email can\'t be blank'
        end
      end

      context 'without attributes' do
        before do
          post '/users', params: nil
        end

        it 'returns bad request status' do
          expect(response.status).to eq 400
        end

        it 'returns correct error' do
          expect(parsed_response[:errors]).to include 'param is missing or the value is empty'
        end
      end
    end

    describe 'PATCH /users/:id' do
      let(:existed_user) { create(:user) }

      context 'with valid attributes' do
        let(:user_email) { 'existed-test@test.com' }

        before do
          patch "/users/#{existed_user.id}", params: {
            user: {
              email: user_email
            }
          }
        end

        it 'returns correct status' do
          expect(response.status).to eq 200
        end

        it 'returns correct values' do
          expect(parsed_response.dig(:data, :email)).to eq user_email
        end

        context 'when user does not exist' do
          before do
            patch '/users/non_existed_id', params: {
              user: {
                email: user_email
              }
            }
          end

          it 'returns not found status' do
            expect(response.status).to eq 404
          end

          it 'returns correct error' do
            expect(parsed_response[:message]).to include 'Couldn\'t find User'
          end
        end
      end

      context 'with not valid attributes' do
        before do
          patch "/users/#{existed_user.id}", params: {
            user: {
              test: 'test'
            }
          }
        end

        it 'returns correct status' do
          expect(response.status).to eq 200
        end

        it 'does not update the email' do
          expect(parsed_response.dig(:data, :email)).to eq existed_user.email
        end
      end

      context 'without attributes' do
        before do
          patch "/users/#{existed_user.id}", params: nil
        end

        it 'returns bad request status' do
          expect(response.status).to eq 400
        end

        it 'returns correct error' do
          expect(parsed_response[:errors]).to include 'param is missing or the value is empty'
        end
      end
    end

    describe 'GET /users/:id' do
      let(:existed_user) { create(:user) }

      before do
        get "/users/#{existed_user.id}"
      end

      it 'returns correct values' do
        expect(parsed_response.dig(:data, :id)).to eq existed_user.id
        expect(parsed_response.dig(:data, :email)).to eq existed_user.email
        expect(parsed_response.dig(:data, :created_at)).to eq existed_user.created_at.iso8601(3)
        expect(parsed_response.dig(:data, :updated_at)).to eq existed_user.updated_at.iso8601(3)
      end

      it 'returns correct status' do
        expect(response.status).to eq 200
      end

      context 'when user does not exist' do
        before do
          get '/users/non_existed_id'
        end

        it 'returns not found status' do
          expect(response.status).to eq 404
        end

        it 'returns correct error' do
          expect(parsed_response[:message]).to include 'Couldn\'t find User'
        end
      end
    end

    describe 'DELETE /users/:id' do
      let(:existed_user) { create(:user) }

      before do
        delete "/users/#{existed_user.id}"
      end

      it 'returns correct status' do
        expect(response.status).to eq 204
      end

      it 'returns empty response' do
        expect(response.body).to be_empty
      end

      context 'when user does not exist' do
        before do
          delete '/users/non_existed_id'
        end

        it 'returns not found status' do
          expect(response.status).to eq 404
        end

        it 'returns correct error' do
          expect(parsed_response[:message]).to include 'Couldn\'t find User'
        end
      end
    end
  end
end
