require 'rails_helper'

RSpec.describe "QuizzesControllers", type: :request do
  describe "GET #index" do
    before do
      get quizzes_url
    end

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'to render index' do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let(:quiz) { create(:quiz) }

    before do
      get quiz_url(quiz)
    end

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'to render show' do
      expect(response).to render_template(:show)
    end
  end

  describe 'PUT #start' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:question) { create(:question) }
    let!(:quiz_question) { create(:quiz_question, quiz: quiz, question: question) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    before do
      put start_quiz_path(quiz)
    end

    it do
      quiz_runner = QuizRunner.find_by(quiz: quiz, user: participant)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(question_path(question_slug: quiz_runner.questions_sorting_order.first))
    end
  end

  describe 'PUT #complete' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:question) { create(:question) }
    let!(:quiz_question) { create(:quiz_question, quiz: quiz, question: question) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    before do
      put complete_quiz_path(quiz)
    end

    it do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(quiz_path(quiz))
    end
  end

  describe 'GET #resume' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:question) { create(:question) }
    let!(:quiz_question) { create(:quiz_question, quiz: quiz, question: question) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    context 'when no quiz is started' do
      before do
        get resume_quiz_path(quiz)
      end

      it do
        expect(response).to redirect_to(quiz_path(quiz))
        expect(flash[:alert]).to match(/Quiz runner doesnot exist/)
      end
    end

    context 'when a quiz is started' do
      before do
        put start_quiz_path(quiz)
      end

      before do
        get resume_quiz_path(quiz)
      end

      it do
        expect(response).to redirect_to(question_path(question_slug: assigns[:quiz_runner].questions_sorting_order.first))
      end
    end
  end

  describe 'GET #submit' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:question) { create(:question) }
    let!(:quiz_question) { create(:quiz_question, quiz: quiz, question: question) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    context 'when no quiz is started' do
      before do
        get submit_quiz_path(quiz)
      end

      it do
        expect(response).to redirect_to(quiz_path(quiz))
        expect(flash[:alert]).to match(/Quiz runner doesnot exist/)
      end
    end

    context 'when a quiz is started' do
      before do
        put start_quiz_path(quiz)
      end

      before do
        get submit_quiz_path(quiz)
      end

      it do
        expect(response).to render_template(:submit)
      end
    end
  end

  describe 'POST #comment' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    before do
      post comment_quiz_path(quiz), params: { comment: { data: 'abc' } }
    end

    it do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(quiz_path(quiz))
    end
  end

  describe 'POST #rate' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    before do
      post rate_quiz_path(quiz)
    end

    it do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(quiz_path(quiz))
    end
  end

  describe 'PATCH #rate' do
    let(:participant) { create(:user) }
    let(:quiz) { create(:quiz) }

    before do
      get "/confirmation?confirmation_token=#{participant.confirmation_token}"
    end

    before do
      patch rate_quiz_path(quiz)
    end

    it do
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(quiz_path(quiz))
    end
  end
end
