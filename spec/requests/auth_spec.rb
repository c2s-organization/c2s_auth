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

    context 'quando os parâmetros são válidos' do
      it 'cria um novo usuário e retorna um token' do
        post '/register', params: valid_attributes.to_json, headers: headers

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'quando os parâmetros são inválidos' do
      it 'não cria o usuário e retorna erros' do
        post '/register', params: { email: '', password: '' }.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'POST /login' do
    let!(:user) { create(:user, password: 'password123') }

    context 'com credenciais válidas' do
      it 'retorna um token JWT' do
        post '/login', params: { email: user.email, password: 'password123' }.to_json, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'com credenciais inválidas' do
      it 'retorna erro de autenticação' do
        post '/login', params: { email: user.email, password: 'wrong_password' }.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'GET /validate_token' do
    let(:valid_token) { JsonWebToken.encode(user_id: user.id) }

    context 'quando o token é válido' do
      it 'retorna uma mensagem de sucesso' do
        get '/validate_token', headers: headers.merge('Authorization' => "Bearer #{valid_token}")

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Token is valid')
      end
    end

    context 'quando o token é inválido' do
      it 'retorna erro de autorização' do
        get '/validate_token', headers: headers.merge('Authorization' => 'Bearer invalid_token')

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end
end
