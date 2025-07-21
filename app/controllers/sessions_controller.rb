# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
    def create
      user = User.find_by(username: params[:username])
      
      if user&.authenticate(params[:password])
        token = jwt_encode(user_id: user.id)
        render json: { token: token, message: "Logged in successfully" }, status: :ok
      else
        render json: { error: "Invalid username or password" }, status: :unauthorized
      end
    end
  
    private
  
    def jwt_encode(payload)
      JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
    end
  end
  
