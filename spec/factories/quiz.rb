FactoryBot.define do
  factory :quiz do
    title { 'A random new quiz for testing' }
    time_limit_in_minutes  { 2 }
    amount { 500 }
    currency_code { 'INR' }
    active { false }
  end
end
