FactoryGirl.define do
  factory :company do
    name { FFaker::Company.name }
    subdomain { FFaker::Internet.domain_word }
  end
end
