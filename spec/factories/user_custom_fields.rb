FactoryBot.define do
  factory :user_custom_field do
    user

    name { 'test' }
    field_type { 'text' }
  end
end
