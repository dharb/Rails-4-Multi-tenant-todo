FactoryGirl.define do
  factory :task do
    title { FFaker::Lorem.sentence }
    complete { false }
    user
  end
end
