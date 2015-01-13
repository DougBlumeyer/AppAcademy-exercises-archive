FactoryGirl.define do
  factory :goal do
    title { Faker::Company.bs }
    description { Faker::Company.catch_phrase }
  end

end
