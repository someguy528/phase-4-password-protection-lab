class SessionsController < ApplicationController
    def create
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            return render json: user 
        else
            render json: {error: "Wrong Username/Password"}, status: :unauthorized
        end
    end

    def destroy
        session.delete :user_id
        head :no_content
    end

end
