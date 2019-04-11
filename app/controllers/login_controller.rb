class LoginController < ApplicationController
  skip_before_action :authenticate_request
  before_action :validate_not_user

  def login
    @current_user = User.authenticate(login_params[:email], login_params[:password])

    if current_user.present?
      render json: {
        access_token: current_user.access_token(request.user_agent)
      }, status: :ok
    else
      render json: {
        message: 'Invalid email or password'
      }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
