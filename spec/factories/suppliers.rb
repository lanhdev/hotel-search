FactoryBot.define do
  factory :supplier do
    sequence(:name) { |n| "supplier#{n + 1}" }
    url { 'http://localhost:3000' }
  end
end
