# frozen_string_literal: true

FactoryBot.define do
  factory :user_custom_field do
    name { 'test' }
    field_type { :text }
  end
end
