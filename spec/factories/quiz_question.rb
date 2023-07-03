FactoryBot.define do
  factory :quiz_question do
    association :quiz
    association :question
  end
end
