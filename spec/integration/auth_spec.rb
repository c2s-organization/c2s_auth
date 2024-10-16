require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/register' do
    post 'Registers a new user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' }
        },
        required: ['email', 'password', 'password_confirmation']
      }

      response '201', 'User registered successfully' do
        let(:user) { { email: 'newuser@example.com', password: 'password123', password_confirmation: 'password123' } }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:user) { { email: 'invalid', password: 'short', password_confirmation: 'mismatch' } }

        run_test!
      end
    end
  end

  path '/login' do
    post 'Logs in a user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', 'User logged in successfully' do
        # Assuming you have a factory or can create a user directly
        before do
          User.create!(email: 'user@example.com', password: 'password123', password_confirmation: 'password123')
        end

        let(:credentials) { { email: 'user@example.com', password: 'password123' } }

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:credentials) { { email: 'user@example.com', password: 'wrongpassword' } }

        run_test!
      end
    end
  end

  path '/validate_token' do
    get 'Validates a JWT token' do
      tags 'Authentication'
      produces 'application/json'
      security [ BearerAuth: [] ]

      response '200', 'Token is valid' do
        # Create a user and generate a valid token for them
        let!(:user) { User.create!(email: 'validuser@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:Authorization) { "Bearer #{WebTokenService.encode(user_id: user.id)}" }

        run_test!
      end

      response '401', 'Unauthorized' do
        # Provide an invalid token
        let(:Authorization) { 'Bearer invalidtoken' }

        run_test!
      end
    end
  end
end
