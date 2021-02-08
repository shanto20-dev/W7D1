class SessionsController < ApplicationController

    def new
        user = User.new
        render :new
    end

    def create
        user = User.find_by_credentials(params[:user][:user_name], params[:user][:password]) 

        if user
            new_session_token = user.reset_session_token!
            session[:session_token] = new_session_token
            redirect_to cats_url
        else
            render :new
        end
    end

    def destroy
        if @current_user
            @current_user.reset_session_token
            session[:session_token] = nil
        end
    end

    

end
