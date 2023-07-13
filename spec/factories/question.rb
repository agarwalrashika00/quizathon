FactoryBot.define do
  factory :question do
    title { 'a new css question' }
    score { 3 }

    before(:create) do |question|
      3.times do
        question.question_options << FactoryBot.build(:question_option, question: question)
      end
      question.question_options << FactoryBot.build(:question_option, question: question, correct: true)
    end
  end
end
