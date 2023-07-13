require 'rails_helper'

RSpec.describe Quiz, type: :model do
  subject {
    described_class.new(title: 'A random new quiz for testing',
                        description: 'This random new quiz is for testing purpose only to check is associations and validations are properly checked.',
                        time_limit_in_seconds: 120,
                        amount: 500,
                        currency_code: 'INR')
  }

  describe "Validations" do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:title) }

    it { should validate_numericality_of(:time_limit_in_seconds) }

    it 'is not valid without 5 length title' do
      subject.title = 'a b c d'
      expect(subject).to_not be_valid
    end

    it 'is not valid without 15 length description' do
      subject.description = 'a b c d e f g h i j k l m n'
      expect(subject).to_not be_valid
    end

    it { should_not allow_value('https://foo.com').for(:description).with_message('invalid format for description') }

    it { should validate_numericality_of(:amount) }
  end

  describe "Associations" do
    it { should have_and_belong_to_many(:genres) }
    it { should have_many(:quiz_questions).dependent(:destroy) }
    it { should have_many(:questions).through(:quiz_questions) }
    it { should have_many(:active_quiz_questions).conditions(active: true).class_name('QuizQuestion') }
    it { should have_many(:active_questions).through(:active_quiz_questions).conditions(active: true).source(:question) }
    it { should accept_nested_attributes_for(:quiz_questions) }
    it { should have_one_attached(:quiz_banner) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:ratings).dependent(:destroy) }
    it { should have_many(:quiz_runners) }
    it { should have_many(:started_quiz_runners).conditions(status: 'started').class_name('QuizRunner') }
    it { should have_many(:users).through(:quiz_runners) }
    it { should have_many(:payments).dependent(:destroy) }
  end

  describe 'callbacks' do
    it { is_expected.to callback(:set_time_limit_in_seconds).before(:validation) }
    it { is_expected.to callback(ActivableCallbacks).before(:validation).on(:update) }
    it { is_expected.to callback(:schedule_mail_if_featured).after(:commit) }
  end

  describe 'Enums' do
    it { 
      should define_enum_for(:level).with_values(
        beginner: 1, easy: 2, moderate: 3, difficult: 4, advance: 5).backed_by_column_of_type(:integer) 
    }
  end

  describe 'scopes' do
    describe 'active' do
      context 'when subject is not active' do
        it 'doesnot return subject' do
          expect(described_class.active).not_to include(subject)
        end
      end
      context 'when a quiz is active' do
        let(:quiz) { create(:quiz, active: true) }

        it 'it returns the quiz' do
          expect(described_class.active).to include(quiz)
        end
      end
    end

    describe 'featured' do
      context 'when featured_at is null' do
        it 'should not return subject' do
          expect(described_class.featured).not_to include(subject)
        end
      end
      context 'when quiz is featured' do
        let!(:quiz) { create(:quiz, active: true, featured_at: Time.current) }
        it 'should return quiz' do
          expect(described_class.featured).to include(quiz)
        end
      end
      context 'when quiz was featured a day before' do
        let(:quiz) { create(:quiz, active: true, featured_at: 1.day.ago) }
        it 'should return quiz' do
          expect(described_class.featured).to include(quiz)
        end
      end
      context 'when quiz was featured a day minus 1 second before' do
        let(:quiz) { create(:quiz, active: true, featured_at: 1.day.ago - 1.second) }
        it 'should not return quiz' do
          expect(described_class.featured).not_to include(quiz)
        end
      end
      context 'when quiz is featured for tomorrow' do
        let(:quiz) { create(:quiz, active: true, featured_at: 1.day.after) }
        it 'should not return quiz' do
          expect(described_class.featured).not_to include(quiz)
        end
      end
    end

    describe 'instance methods' do
      let(:quiz) { create(:quiz) }

      describe 'to param' do
        it 'should return slug' do
          expect(quiz.to_param).to eq(quiz.slug)
        end
      end

      describe 'average rating' do
        it 'should return average rating' do
          expect(quiz.average_rating).to eq(quiz.ratings.average(:value))
        end
      end

      describe 'feature now' do
        it 'should change value of featured_at column' do
          quiz.feature_now
          expect(quiz.featured_at).to be_between(Time.current - 1.minute, Time.current)
        end
      end
    end
  end
end
