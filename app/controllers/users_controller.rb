class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  before_action :validate_not_user, only: :create

  def create
    @current_user = User.new(create_params)

    if current_user.save
      render json: {
        user: current_user,
        access_token: current_user.access_token(request.user_agent)
      }, status: :ok
    else
      render json: {
        message: instance_error_message(
          current_user,
          'We were unable to sign you up'
        )
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: { user: current_user }, status: :ok
  end

  def update
    if current_user.update_attributes(update_params)
      render json: { user: current_user }, status: :ok
    else
      render json: {
        message: instance_error_message(
          current_user,
          'We were unable to update your user'
        )
      }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
