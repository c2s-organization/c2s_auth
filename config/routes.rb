Rails.application.routes.draw do
  post 'register', to: 'auth#register'
  post 'login', to: 'auth#login'
  get 'validate_token', to: 'auth#validate_token'
end
