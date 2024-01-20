# frozen_string_literal: true

require 'rails_helper'

describe 'UserCustomFields', type: :request do
  describe 'POST /user_custom_fields' do
    context 'with valid attributes' do
      let(:name) { 'test name' }
      let(:internal_name) { 'test_name' }
      let(:field_type) { 'number' }
      let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

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
      end
    end

    context 'with not valid attributes' do
      let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

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

    context 'without attributes' do
      let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

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
end
