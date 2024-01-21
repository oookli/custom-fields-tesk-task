# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  context 'without custom fields' do
    let(:user) { create(:user) }

    it 'is valid' do
      expect(user).to be_valid
    end

    context 'when email is not provided' do
      let(:user) { build(:user, email: nil) }

      it 'is not valid' do
        expect(user).not_to be_valid
      end
    end
  end

  context 'with custom fields' do
    before do
      create(:user_custom_field, name: 'name', field_type: :text)
      create(:user_custom_field, name: 'age', field_type: :number)
      create(:user_custom_field, name: 'gender', field_type: :dropdown, options: %w[male female other])
      create(:user_custom_field, name: 'movie genre',
                                 field_type: :multi_dropdown,
                                 options: %w[action comedy drama science])
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
      user.gender = 'male'
      user.movie_genre = %w[action drama]
      user.save

      expect(user).to be_valid

      user.reload

      expect(user.name).to eq 'test'
      expect(user.age).to eq 25
      expect(user.custom_fields)
        .to include 'age' => 25, 'name' => 'test', 'gender' => 'male', 'movie_genre' => %w[action drama]
    end

    context 'when custom field with number type is set with wrong value' do
      it 'raises an error' do
        user.age = 'some age'
        user.validate

        expect(user.errors.full_messages).to include(match('Age is not a number'))
      end
    end

    context 'when custom field with dropdown type is set with wrong value' do
      it 'raises an error' do
        user.gender = 'hm'
        user.validate

        expect(user.errors.full_messages).to include(match('Gender is not included in the list'))
      end
    end

    context 'when custom field with multiple dropdown type is set with wrong value' do
      it 'raises an error' do
        user.movie_genre = %w[drama fiction]
        user.validate

        expect(user.errors.full_messages).to include(match('Movie genre is not included in the list'))
      end
    end
  end
end
