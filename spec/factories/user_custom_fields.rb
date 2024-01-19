FactoryBot.define do
  factory :user_custom_field do
    user

    name { 'test' }
    type { :text }
  end
end
