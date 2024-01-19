# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCustomField, type: :model do
  let(:name) { 'some test name' }
  let(:type) { :text }
  let(:user_custom_field) { create(:user_custom_field, name: name, type: type) }

  it 'is valid' do
    expect(user_custom_field).to be_valid
  end

  # it 'generates correct internal_name' do
  #   expect(user_custom_field.internal_name).to eq 'some_test_name'
  # end
end
