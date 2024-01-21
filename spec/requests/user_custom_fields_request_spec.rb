# frozen_string_literal: true

require 'rails_helper'

describe 'UserCustomFields', type: :request do
  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  describe 'GET /user_custom_fields' do
    before do
      create(:user_custom_field, name: 'some text field', field_type: :text)
      create(:user_custom_field, name: 'some number field', field_type: :number)
      create(:user_custom_field, name: 'some select field', field_type: :dropdown, options: %w[test1 test2])
      create(:user_custom_field, name: 'some multi select field', field_type: :multi_dropdown, options: %w[test3 test4])
    end

    before do
      get '/user_custom_fields'
    end

    it 'returns correct status' do
      expect(response.status).to eq 200
    end

    it 'returns correct data' do
      expect(parsed_response[:data].count).to eq 4
      expect(parsed_response.dig(:data, 0, :name)).to eq 'some text field'
      expect(parsed_response.dig(:data, 0, :field_type)).to eq 'text'
      expect(parsed_response.dig(:data, 0, :options)).to be_nil
      expect(parsed_response.dig(:data, 1, :name)).to eq 'some number field'
      expect(parsed_response.dig(:data, 1, :field_type)).to eq 'number'
      expect(parsed_response.dig(:data, 1, :options)).to be_nil
      expect(parsed_response.dig(:data, 2, :name)).to eq 'some select field'
      expect(parsed_response.dig(:data, 2, :field_type)).to eq 'dropdown'
      expect(parsed_response.dig(:data, 2, :options)).to eq %w[test1 test2]
      expect(parsed_response.dig(:data, 3, :name)).to eq 'some multi select field'
      expect(parsed_response.dig(:data, 3, :field_type)).to eq 'multi_dropdown'
      expect(parsed_response.dig(:data, 3, :options)).to eq %w[test3 test4]
    end
  end

  describe 'POST /user_custom_fields' do
    context 'when field type is number' do
      context 'with valid attributes' do
        let(:name) { 'test name' }
        let(:internal_name) { 'test_name' }
        let(:field_type) { 'number' }

        before do
          post '/user_custom_fields', params: {
            user_custom_field: {
              name:,
              field_type:
            }
          }
        end

        it 'returns status created' do
          expect(response.status).to eq 201
        end

        it 'returns correct values' do
          expect(parsed_response[:data][:name]).to eq name
          expect(parsed_response[:data][:internal_name]).to eq internal_name
          expect(parsed_response[:data][:field_type]).to eq field_type
          expect(parsed_response[:data][:options]).to be_nil
        end
      end

      context 'with not valid attributes' do
        before do
          post '/user_custom_fields', params: {
            user_custom_field: {
              test: 'test'
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Name can\'t be blank'
          expect(parsed_response[:errors]).to include 'Internal name can\'t be blank'
        end
      end
    end

    context 'when field type is dropdown' do
      let(:name) { 'test name' }
      let(:field_type) { 'dropdown' }

      context 'with valid attributes' do
        let(:internal_name) { 'test_name' }
        let(:options) { %w[some_test some_another_test] }

        before do
          post '/user_custom_fields', params: {
            user_custom_field: {
              name:,
              field_type:,
              options:
            }
          }
        end

        it 'returns status created' do
          expect(response.status).to eq 201
        end

        it 'returns correct values' do
          expect(parsed_response[:data][:name]).to eq name
          expect(parsed_response[:data][:internal_name]).to eq internal_name
          expect(parsed_response[:data][:field_type]).to eq field_type
          expect(parsed_response[:data][:options]).to eq options
        end
      end

      context 'with not valid attributes' do
        before do
          post '/user_custom_fields', params: {
            user_custom_field: {
              name:,
              field_type:
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Options can\'t be blank'
        end
      end
    end

    context 'when field type is multi_dropdown' do
      let(:name) { 'test name' }
      let(:field_type) { 'multi_dropdown' }

      context 'with valid attributes' do
        let(:internal_name) { 'test_name' }
        let(:options) { %w[some_another_test blah] }

        before do
          post '/user_custom_fields', params: {
            user_custom_field: {
              name:,
              field_type:,
              options:
            }
          }
        end

        it 'returns status created' do
          expect(response.status).to eq 201
        end

        it 'returns correct values' do
          expect(parsed_response[:data][:name]).to eq name
          expect(parsed_response[:data][:internal_name]).to eq internal_name
          expect(parsed_response[:data][:field_type]).to eq field_type
          expect(parsed_response[:data][:options]).to eq options
        end
      end

      context 'with not valid attributes' do
        before do
          post '/user_custom_fields', params: {
            user_custom_field: {
              name:,
              field_type:
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Options can\'t be blank'
        end
      end
    end

    context 'without attributes' do
      before do
        post '/user_custom_fields', params: nil
      end

      it 'returns bad request status' do
        expect(response.status).to eq 400
      end

      it 'returns correct error' do
        expect(parsed_response[:errors]).to include 'param is missing or the value is empty'
      end
    end
  end

  describe 'PATCH /user_custom_fields/:id' do
    let(:existed_user_custom_field) { create(:user_custom_field, name: 'some initial name', field_type: :text) }

    context 'when field type is number' do
      context 'with valid attributes' do
        let(:updated_field_type) { :number }
        let(:updated_name) { 'some better name' }

        before do
          patch "/user_custom_fields/#{existed_user_custom_field.id}", params: {
            user_custom_field: {
              name: updated_name,
              field_type: updated_field_type
            }
          }
        end

        it 'returns correct status' do
          expect(response.status).to eq 200
        end

        it 'returns correct values' do
          expect(parsed_response.dig(:data, :name)).to eq updated_name
          expect(parsed_response.dig(:data, :field_type)).to eq updated_field_type.to_s
        end

        context 'when user custom field does not exist' do
          before do
            patch '/user_custom_fields/non_existed_id', params: {
              user_custom_field: {
                name: updated_name,
                field_type: updated_field_type
              }
            }
          end

          it 'returns not found status' do
            expect(response.status).to eq 404
          end

          it 'returns correct error' do
            expect(parsed_response[:message]).to include 'Couldn\'t find UserCustomField'
          end
        end
      end

      context 'with not valid attributes' do
        before do
          patch "/user_custom_fields/#{existed_user_custom_field.id}", params: {
            user_custom_field: {
              test: 'test'
            }
          }
        end

        it 'returns correct status' do
          expect(response.status).to eq 200
        end

        it 'does not update values' do
          expect(parsed_response.dig(:data, :name)).to eq existed_user_custom_field.name
          expect(parsed_response.dig(:data, :field_type)).to eq existed_user_custom_field.field_type
        end
      end
    end

    context 'when field type is dropdown' do
      let(:updated_field_type) { :dropdown }
      let(:updated_name) { 'some better name' }

      context 'with valid attributes' do
        let(:updated_options) { %w[test5 test6] }

        before do
          patch "/user_custom_fields/#{existed_user_custom_field.id}", params: {
            user_custom_field: {
              name: updated_name,
              field_type: updated_field_type,
              options: updated_options
            }
          }
        end

        it 'returns correct status' do
          expect(response.status).to eq 200
        end

        it 'returns correct values' do
          expect(parsed_response.dig(:data, :name)).to eq updated_name
          expect(parsed_response.dig(:data, :field_type)).to eq updated_field_type.to_s
          expect(parsed_response.dig(:data, :options)).to eq updated_options
        end

        context 'when user custom field does not exist' do
          before do
            patch '/user_custom_fields/non_existed_id', params: {
              user_custom_field: {
                name: updated_name,
                field_type: updated_field_type,
                options: updated_options
              }
            }
          end

          it 'returns not found status' do
            expect(response.status).to eq 404
          end

          it 'returns correct error' do
            expect(parsed_response[:message]).to include 'Couldn\'t find UserCustomField'
          end
        end
      end

      context 'with not valid attributes' do
        before do
          patch "/user_custom_fields/#{existed_user_custom_field.id}", params: {
            user_custom_field: {
              name: updated_name,
              field_type: updated_field_type
            }
          }
        end

        it 'returns unprocessable entity status' do
          expect(response.status).to eq 422
        end

        it 'returns correct errors' do
          expect(parsed_response[:errors]).to include 'Options can\'t be blank'
        end
      end
    end

    context 'without attributes' do
      before do
        patch "/user_custom_fields/#{existed_user_custom_field.id}", params: nil
      end

      it 'returns bad request status' do
        expect(response.status).to eq 400
      end

      it 'returns correct error' do
        expect(parsed_response[:errors]).to include 'param is missing or the value is empty'
      end
    end
  end

  describe 'DELETE /user_custom_fields/:id' do
    let(:existed_user_custom_field) { create(:user_custom_field) }

    before do
      delete "/user_custom_fields/#{existed_user_custom_field.id}"
    end

    it 'returns correct status' do
      expect(response.status).to eq 204
    end

    it 'returns empty response' do
      expect(response.body).to be_empty
    end

    context 'when user custom field does not exist' do
      before do
        delete '/user_custom_fields/non_existed_id'
      end

      it 'returns not found status' do
        expect(response.status).to eq 404
      end

      it 'returns correct error' do
        expect(parsed_response[:message]).to include 'Couldn\'t find UserCustomField'
      end
    end
  end
end
