FactoryGirl.define do
  factory :user do
    sequence(:name)     { |n| "Name #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password 'password'
    password_confirmation 'password'
  end
end
