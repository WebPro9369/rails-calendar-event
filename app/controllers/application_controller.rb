class ApplicationController < ActionController::API
  include Concerns::SaveError

  attr_accessor :current_user

  before_action :set_current_user, :authenticate_request
  skip_before_action :authenticate_request, only: :route_not_found

  rescue_from Util::JsonWebToken::InvalidTokenError, with: :invalid_token_error
  rescue_from ActionController::RoutingError, with: :route_not_found_handler

  def route_not_found
    raise ActionController::RoutingError.new(params[:path])
  end

  private

  def set_current_user
    if request.headers[:token].present?
      @current_user = User.get_user_from_token(
        request.headers[:token],
        request.user_agent
      )
    end
  end

  def authenticate_request
    return if current_user.present?

    return render json: { message: 'Not Authorized' }, status: :unauthorized
  end

  def validate_not_user
    unless current_user.nil?
      return render json: {
        message: 'You already have an account'
      }, status: :unauthorized
    end
  end

  def invalid_token_error
    return render json: { message: 'Invalid login credentials' }, status: :unauthorized
  end

  def route_not_found_handler
    return render json: { message: 'Route not found' }, status: :not_found
  end
end
