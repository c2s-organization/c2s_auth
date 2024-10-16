# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1', # Ensure a valid OpenAPI version is specified
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        securitySchemes: {
          BearerAuth: { # Define security scheme for JWT
                        type: :http,
                        scheme: :bearer,
                        bearerFormat: :JWT
          }
        },
        schemas: { # Define reusable schemas
                   UserRegistration: {
                     type: :object,
                     required: ['email', 'password', 'password_confirmation'],
                     properties: {
                       email: { type: :string, example: 'user@example.com' },
                       password: { type: :string, example: 'password123' },
                       password_confirmation: { type: :string, example: 'password123' }
                     }
                   },
                   UserLogin: {
                     type: :object,
                     required: ['email', 'password'],
                     properties: {
                       email: { type: :string, example: 'user@example.com' },
                       password: { type: :string, example: 'password123' }
                     }
                   },
                   AuthToken: {
                     type: :object,
                     properties: {
                       token: { type: :string, example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6...' }
                     },
                     required: ['token']
                   },
                   ErrorResponse: {
                     type: :object,
                     properties: {
                       errors: {
                         type: :array,
                         items: { type: :string },
                         example: ['Invalid email or password']
                       }
                     },
                     required: ['errors']
                   },
                   SuccessMessage: {
                     type: :object,
                     properties: {
                       message: { type: :string, example: 'Token is valid' }
                     },
                     required: ['message']
                   }
        }
      }
    }
  }

  config.swagger_format = :yaml
end
