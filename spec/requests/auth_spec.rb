require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'POST /register' do
    let(:valid_attributes) do
      {
        email: Faker::Internet.email,
        password: 'password123',
        password_confirmation: 'password123'
      }
    end

    context 'when the parameters are valid' do
      it 'creates a new user and returns a token' do
        post '/register', params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'when the parameters are invalid' do
      it 'does not create the user and returns errors' do
        post '/register', params: { email: '', password: '' }.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'POST /login' do
    let!(:user) { create(:user, password: 'password123') }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/login', params: { email: user.email, password: 'password123' }.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      it 'returns an authentication error' do
        post '/login', params: { email: user.email, password: 'wrong_password' }.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'GET /validate_token' do
    let(:valid_token) { WebTokenService.encode(user_id: user.id) }

    context 'when the token is valid' do
      it 'returns a success message' do
        get '/validate_token', headers: headers.merge('Authorization' => "Bearer #{valid_token}")

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Token is valid')
      end
    end

    context 'when the token is invalid' do
      it 'returns an authorization error' do
        get '/validate_token', headers: headers.merge('Authorization' => 'Bearer invalid_token')

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end
end
