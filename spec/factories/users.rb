FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    password "password"
    password_confirmation "password"
    company
  end
end
