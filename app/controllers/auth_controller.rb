class AuthController < ApplicationController
  before_action :authorize_request, except: [:login, :register]

  def register
    user = User.new(user_params)
    if user.save
      render_token(user, :created)
    else
      render_errors(user.errors.full_messages, :unprocessable_entity)
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render_token(user, :ok)
    else
      render_errors(['Invalid email or password'], :unauthorized)
    end
  end

  def validate_token
    render json: { message: 'Token is valid' }, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def authorize_request
    header = request.headers['Authorization']
    return render_errors(['Unauthorized'], :unauthorized) unless header

    token = header.split(' ').last
    decoded_token = WebTokenService.decode(token)
    return render_errors(['Unauthorized'], :unauthorized) unless decoded_token

    @current_user = User.find_by(id: decoded_token[:user_id])
    render_errors(['Unauthorized'], :unauthorized) unless @current_user
  end

  def render_token(user, status)
    token = WebTokenService.encode(user_id: user.id)
    render json: { token: token }, status: status
  end

  def render_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end
