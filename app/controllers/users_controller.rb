class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :rescue_invalid
before_action :authorize, only: [:show]
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            return render json: user 
        else
            render json: {error: "unauthorized"}, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
    def rescue_invalid(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
    def authorize
        return render json: {error: "Not Authorized"}, status: :unauthorized unless session.include? :user_id
    end

end
