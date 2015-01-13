FactoryGirl.define do
  factory :comment do
    body { Faker::Hacker.say_something_smart }
  end
end
