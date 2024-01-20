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

  context 'with custom fields' do
    before do
      create(:user_custom_field, name: 'first name', field_type: :text)
      create(:user_custom_field, name: 'age', field_type: :number)
    end

    describe 'GET /users' do
      let!(:user1) { create(:user, email: 'test1@test.com') }
      let!(:user2) { create(:user, email: 'test2@test.com', first_name: 'second user', age: 25) }
      let!(:user3) { create(:user, email: 'test3@test.com', first_name: 'third user', age: 30) }

      before do
        get '/users'
      end

      it 'returns correct status' do
        expect(response.status).to eq 200
      end

      it 'returns correct data' do
        expect(parsed_response[:data].count).to eq 3
        expect(parsed_response.dig(:data, 0, :email)).to eq 'test1@test.com'
        expect(parsed_response.dig(:data, 0, :custom_fields, :first_name)).to eq nil
        expect(parsed_response.dig(:data, 0, :custom_fields, :age)).to eq nil
        expect(parsed_response.dig(:data, 1, :email)).to eq 'test2@test.com'
        expect(parsed_response.dig(:data, 1, :custom_fields, :first_name)).to eq 'second user'
        expect(parsed_response.dig(:data, 1, :custom_fields, :age)).to eq 25
        expect(parsed_response.dig(:data, 2, :email)).to eq 'test3@test.com'
        expect(parsed_response.dig(:data, 2, :custom_fields, :first_name)).to eq 'third user'
        expect(parsed_response.dig(:data, 2, :custom_fields, :age)).to eq 30
      end
    end

    describe 'POST /users' do
      let(:user_email) { 'new-test@test.com' }

      context 'with valid attributes' do
        let(:user_first_name) { 'new first name' }
        let(:user_age) { 20 }

        before do
          post '/users', params: {
            user: {
              email: user_email,
              first_name: user_first_name,
              age: user_age
            }
          }
        end

        it 'returns status created' do
          expect(response.status).to eq 201
        end

        it 'returns correct values' do
          expect(parsed_response.dig(:data, :email)).to eq user_email
          expect(parsed_response.dig(:data, :custom_fields, :first_name)).to eq user_first_name
          expect(parsed_response.dig(:data, :custom_fields, :age)).to eq user_age.to_s
        end
      end

      context 'with not valid attributes' do
        before do
          post '/users', params: {
            user: {
              email: user_email,
              age: 'test age'
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Age is not a number'
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
      let(:existed_user) { create(:user, first_name: 'test', age: 10) }

      context 'with valid attributes' do
        let(:user_updated_first_name) { 'new updated first name' }
        let(:user_updated_age) { 50 }

        before do
          patch "/users/#{existed_user.id}", params: {
            user: {
              first_name: user_updated_first_name,
              age: user_updated_age
            }
          }
        end

        it 'returns correct status' do
          expect(response.status).to eq 200
        end

        it 'returns correct values' do
          expect(parsed_response.dig(:data, :email)).to eq existed_user.email
          expect(parsed_response.dig(:data, :custom_fields, :first_name)).to eq user_updated_first_name
          expect(parsed_response.dig(:data, :custom_fields, :age)).to eq user_updated_age.to_s
        end

        context 'when user does not exist' do
          before do
            patch '/users/non_existed_id', params: {
              user: {
                first_name: user_updated_first_name,
                age: user_updated_age
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
              age: 'too old for that s**t'
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Age is not a number'
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
      let(:user_first_name) { 'some first name' }
      let(:user_age) { 26 }
      let(:existed_user) { create(:user, first_name: user_first_name, age: user_age) }

      before do
        get "/users/#{existed_user.id}"
      end

      it 'returns correct values' do
        expect(parsed_response.dig(:data, :id)).to eq existed_user.id
        expect(parsed_response.dig(:data, :email)).to eq existed_user.email
        expect(parsed_response.dig(:data, :custom_fields, :first_name)).to eq user_first_name
        expect(parsed_response.dig(:data, :custom_fields, :age)).to eq user_age
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
