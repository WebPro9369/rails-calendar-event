class CalendarsController < ApplicationController
  before_action :get_calendar, only: [:show, :month_events]
  before_action :check_date, only: [:month_events]

  attr_accessor :calendar, :date

  def create
    calendar = Calendar.new(create_params)

    if calendar.save
      render json: { calendar: calendar }, status: :ok
    else
      render json: {
        message: instance_error_message(
          calendar,
          'We were unable to save your calendar'
        )
      }, status: :unprocessable_entity
    end
  end

  def show
    render json: { calendar: calendar }, status: :ok
  end

  def show_user_calendars
    render json: { calendars: current_user.calendars }, status: :ok
  end

  def month_events
    events = calendar.get_month_events(date)

    render json: { events: events }, status: :ok
  end

  private

  def create_params
    params.require(:calendar).permit(
      :title
    ).merge(
      user_id: current_user.id
    )
  end

  def get_calendar
    @calendar = Calendar.find_by(
      id: params[:id],
      user_id: current_user.id
    )

    if calendar.nil?
      return render json: {
        message: 'We could not find your calendar'
      }, status: :not_found
    end
  end

  def check_date
    @date = params[:date].to_datetime
  rescue StandardError => e
    return render json: {
      message: 'Invalid date'
    }, status: :unprocessable_entity
  end
end
