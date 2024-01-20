# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'without custom fields' do
    let(:user) { create(:user) }

    it 'is valid' do
      expect(user).to be_valid
    end
  end

  context 'with custom fields' do
    before do
      create(:user_custom_field, name: 'name', field_type: :text)
      create(:user_custom_field, name: 'age', field_type: :number)
    end

    let(:user) { build(:user) }

    it 'is valid' do
      expect(user).to be_valid
    end

    it 'saves a record without custom fields' do
      user.save

      expect(user).to be_valid
    end

    it 'saves custom fields correctly' do
      user.name = 'test'
      user.age = 25
      user.save

      expect(user).to be_valid

      user.reload

      expect(user.name).to eq 'test'
      expect(user.age).to eq 25
      expect(user.custom_fields).to include 'age' => 25, 'name' => 'test'
    end

    context 'when custom field with number type is set with wrong value' do
      it 'raises an error' do
        user.age = 'some age'
        user.validate

        expect(user.errors.full_messages).to include(match('Age is not a number'))
      end
    end
  end
end
