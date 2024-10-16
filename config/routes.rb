Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post 'register', to: 'auth#register'
  post 'login', to: 'auth#login'
  get 'validate_token', to: 'auth#validate_token'
end
