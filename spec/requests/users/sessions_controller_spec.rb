require 'rails_helper'

RSpec.describe "Users::SessionsControllers", type: :request do

  describe 'GET /sign_in', type: :request do
    before do
      get '/sign_in'
    end

    it 'opens sign in page' do
      expect(response.body).to match(/Log in/)
      expect(response).to render_template(:new)
    end
  end

  describe "GET /confirmation", type: :request do
    context 'when user is participant' do
      let(:participant) { create(:user) }

      before do
        get "/confirmation?confirmation_token=#{participant.confirmation_token}"
      end

      it 'can view his profile' do
        get '/profile'
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end

      it 'cannot view all users' do
        get '/admin/users'
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match(/You donot have privileges to access this section/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
      end

      it 'can view all users' do
        get '/admin/users'
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'DELETE /sign_out', type: :request do
    context 'when user is participant' do
      let(:participant) { create(:user) }

      before do
        get "/confirmation?confirmation_token=#{participant.confirmation_token}"
      end

      it 'gets logged out' do
        delete '/sign_out'
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to match(/Signed out successfully/)
      end
    end

    context 'when user is admin' do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
      end

      it 'gets logged out' do
        delete '/sign_out'
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to match(/Signed out successfully/)
      end
    end
  end
end
