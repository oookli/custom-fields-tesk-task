# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCustomField, type: :model do
  let(:name) { 'some test name' }
  let(:type) { :number }
  let(:user_custom_field) { create(:user_custom_field, name: name, field_type: type) }

  it 'is valid' do
    expect(user_custom_field).to be_valid
  end

  it 'generates correct internal_name' do
    expect(user_custom_field.internal_name).to eq 'some_test_name'
  end

  context 'when field type is not correct' do
    let(:invalid_type) { :blabla }

    it 'raises record invalid error' do
      expect { create(:user_custom_field, field_type: invalid_type) }.to raise_error(
        ArgumentError, /is not a valid field_type/
      )
    end
  end

  context 'when name is not provided' do
    let(:user_custom_field) { build(:user_custom_field, name: nil) }

    before { user_custom_field.validate }

    it 'is not valid' do
      expect(user_custom_field).not_to be_valid
    end

    it 'raises internal_name error as well' do
      expect(user_custom_field.errors.full_messages).to include(match('Internal name can\'t be blank'))
    end
  end

  context 'when field_type is not provided' do
    let(:user_custom_field) { build(:user_custom_field, field_type: nil) }

    it 'is not valid' do
      expect(user_custom_field).not_to be_valid
    end
  end

  context 'when user is not provided' do
    let(:user_custom_field) { build(:user_custom_field, user: nil) }

    it 'is not valid' do
      expect(user_custom_field).not_to be_valid
    end
  end
end
