FactoryBot.define do
  factory :question_option do
    data { 'abc' }
    correct { false }
    association :question
  end
end
