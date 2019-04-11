module Util
  class JsonWebToken
    class InvalidTokenError < StandardError; end

    ALGORITHM = 'HS256'.freeze
    SECRET = Rails.application.secrets.secret_key_base.dup.freeze

    class << self
      def encode(user, user_agent)
        validate_options(user, user_agent)

        JWT.encode(
          {
            user_id: user.id,
            user_agent: user_agent
          },
          SECRET,
          ALGORITHM
        )
      end

      def decode(token)
        validate_token(token)

        decode_token(token)
      end

      private

      def decode_token(token)
        decoded_token = JWT.decode(
          token,
          SECRET,
          true,
          { algorithm: ALGORITHM }
        )

        HashWithIndifferentAccess.new(decoded_token.first).symbolize_keys
      rescue
      end

      def validate_options(user, user_agent)
        return if user.is_a?(User) && user_agent.is_a?(String)

        raise_error('Missing or invalid user token options')
      end

      def validate_token(token)
        return if token.is_a?(String)

        raise_error('Missing or invalid authentication')
      end

      def raise_error(message)
        raise InvalidTokenError.new(message)
      end
    end
  end
end
