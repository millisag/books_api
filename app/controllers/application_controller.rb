class ApplicationController < ActionController::API  
    before_action :authenticate_request
  
    attr_reader :current_user
  
    private
  
    def authenticate_request
      token = extract_token_from_header
      decoded_token = decode_token(token)
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @current_user = User.find_by(id: user_id)
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  
    def extract_token_from_header
      auth_header = request.headers['Authorization']
      if auth_header.present? && auth_header.start_with?('Bearer ')
        auth_header.split(' ').last
      end
    end
  
    def decode_token(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
    end
  end  
