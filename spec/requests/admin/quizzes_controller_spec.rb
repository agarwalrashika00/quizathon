require 'rails_helper'

RSpec.describe "Admin::QuizzesControllers", type: :request do
  describe 'GET #index' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        get admin_quizzes_path
      end
      it 'cannot view all quizzes' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      let!(:quizzes) { create_list(:quiz, 4) }
      before do
        sign_in admin
        get admin_quizzes_path
      end
      it 'can view all quizzes' do
        expect(assigns(:quizzes)).to include(quizzes.first)
        expect(response).to render_template('admin/quizzes/index')
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        get '/admin/quizzes/new'
      end
      it 'cannot create a new quiz' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      before do
        sign_in admin
        get '/admin/quizzes/new'
      end
      it 'can create a new quiz' do
        expect(response).to render_template('admin/quizzes/new')
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        post '/admin/quizzes', params: { quiz: {title: 'abc'} }
      end
      it 'cannot create a new quiz' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      let(:quiz) { build(:quiz) }
      before do
        sign_in admin
        post '/admin/quizzes', params: { quiz: {title: quiz.title, time_limit_in_minutes: 2, amount: 500} }
      end
      it 'can create a new quiz' do
        expect(response).to redirect_to(admin_quizzes_path)
        expect(flash[:notice]).to match(/Quiz created successfully/)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:quiz) { create(:quiz) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        get edit_admin_quiz_path(quiz)
      end
      it 'cannot edit the quiz' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      let(:quiz) { create(:quiz) }
      before do
        sign_in admin
        get edit_admin_quiz_path(quiz)
      end
      it 'can edit the quiz' do
        expect(response).to render_template('admin/quizzes/edit')
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:quiz) { create(:quiz) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        patch admin_quiz_path(quiz)
      end
      it 'cannot update the quiz' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      let(:quiz) { create(:quiz) }
      before do
        sign_in admin
        patch admin_quiz_path(quiz), params: { quiz: { title: quiz.title, time_limit_in_minutes: 2, amount: 500 } }
      end
      it 'can update the quiz' do
        expect(response).to redirect_to(admin_quizzes_path)
        expect(flash[:notice]).to match(/Quiz [\w|\s]* was successfully updated/)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:quiz) { create(:quiz) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        delete admin_quiz_path(quiz)
      end
      it 'cannot delete the quiz' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      let!(:quiz) { create(:quiz) }
      before do
        sign_in admin
        delete admin_quiz_path(quiz)
      end
      it 'can delete the quiz' do
        expect(response).to redirect_to(admin_quizzes_path)
        expect(flash[:alert]).to match(/Quiz destroyed successfully/)
      end
    end
  end

  describe 'PATCH #feature' do
    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:quiz) { create(:quiz) }
      before do
        get "/confirmation?confirmation_token=#{user.confirmation_token}"
        patch feature_admin_quiz_path(quiz)
      end
      it 'cannot feature the quiz' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }
      let!(:quiz) { create(:quiz) }
      before do
        sign_in admin
        patch feature_admin_quiz_path(quiz)
      end
      it 'can feature the quiz' do
        expect(Quiz.find_by_id(quiz.id).featured_at).to be_between(Time.current - 1.minute, Time.current)
        expect(response).to redirect_to(admin_quizzes_path)
        expect(flash[:notice]).to match(/Quiz featured successfully/)
      end
    end
  end
end
