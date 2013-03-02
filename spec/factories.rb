FactoryGirl.define do
  factory :beer do
    association :brewery
    association :user
    association :beer_style
    name        "Strawberry Harvest"
    description "Strawberry Harvest Lager is a wheat beer made with real Louisiana strawberries."
    abv         4.2
  end

  factory :beer_style do
    association :user
    name        "American IPA"
    description "A very delicious ale."
  end

  factory :brewery do
    association :user
    name        "Abita"
  end

  factory :user do
    name                  "Sue"
    email
    password              "test"
    password_confirmation "test"
  end

  sequence :email do |n|
    "user#{n}@example.com"
  end
end
