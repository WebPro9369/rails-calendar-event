class EventsController < ApplicationController
  before_action :get_event, only: [:show, :update, :delete]

  attr_accessor :event

  def create
    @event = Event.new(create_params)

    if event.save
      render json: { event: event }, status: :ok
    else
      render json: {
        message: instance_error_message(
          event,
          'We were unable to create your event'
        )
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: { event: event }, status: :ok
  end

  def update
    if event.update_attributes(update_params)
      render json: { event: event }, status: :ok
    else
      render json: {
        message: instance_error_message(
          event,
          'We were unable to update your event'
        )
      }, status: :unprocessable_entity
    end
  end

  def delete
    if event.mark_deleted
      render json: {
        message: "#{event.title} successfully deleted"
      }, status: :ok
    else
      render json: {
        message: 'Unable to delete your event'
      }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.require(:event).permit(
      :title,
      :note,
      :start_time,
      :end_time
    ).merge(
      calendar_id: params[:calendar_id],
      user_id: current_user.id
    )
  end

  def update_params
    params.require(:event).permit(
      :title,
      :note,
      :start_time,
      :end_time
    )
  end

  def get_event
    @event = Event.find_by(
      id: params[:id],
      calendar_id: params[:calendar_id],
      user_id: current_user.id
    )

    if event.nil?
      return render json: {
        message: 'We could not find your event'
      }, status: :not_found
    end
  end
end
