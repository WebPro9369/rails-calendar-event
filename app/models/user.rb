class User < ApplicationRecord
  has_secure_password

  has_many :calendars
  has_many :events

  validates :name, presence: true
  validates :email, presence: true, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  }, uniqueness: {
    case_sensitive: false
  }
  validate :validate_first_and_last

  before_validation :format_email
  after_create :create_calendar

  def access_token(user_agent)
    Util::JsonWebToken.encode(self, user_agent)
  end

  class << self
    def authenticate(email, password)
      user = find_by_email(email)

      user if user.present? && user.authenticate(password)
    end

    def get_user_from_token(access_token, user_agent)
      token = Util::JsonWebToken.decode(access_token)

      return unless token.is_a?(Hash) && token[:user_agent] == user_agent

      find_by_id(token[:user_id])
    end
  end

  private

  def create_calendar
    Calendar.create!(title: name, user_id: id)
  end

  def format_email
    return if email.nil?

    self.email = email.downcase
  end

  def validate_first_and_last
    return unless name.present? && name.split(' ').length < 2

    errors.add(:name, 'must contain your first and last names')
  end
end
