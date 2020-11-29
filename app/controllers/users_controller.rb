class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
    end

  def create
    if session[:user_id]
      flash[:status] = :failure
      flash[:result_text] = "User is already logged in"
      redirect_back(fallback_location: root_path)
    else
        auth_hash = request.env["omniauth.auth"]

        user = User.find_by(uid: auth_hash[:uid], provider: params[:provider])

        if user #user exists
          flash[:status] = :success
          flash[:result_text] = "Successfully logged in as existing user #{user.username}"
        else #user doesn't exist
        user = User.build_from_github(auth_hash)

        if user.save
          flash[:status] = :success
          flash[:result_text] = "Logged in as new user #{user.username}"

        else
          flash.now[:status] = :failure
          flash.now[:result_text] = "Could not create user account"
          flash.now[:messages] = user.errors.messages

      return redirect_to root_path
    end
    end
    session[:user_id] = user.id
    return redirect_to root_path
    end
  end

  def logout
    if session[:user_id]
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
    else
      flash[:status] = :failure
      flash[:result_text] = "You are not logged in"
      redirect_to root_path
      return
    end
  end

    # def current
    # @current_user = User.find_by(id: session[:user_id])
    # unless @current_user
    #   flash.now[:status] = :failure
    #   flash.now[:result_text] = "You must be logged in to see this page"
    #   flash.now[:messages] = user.errors.messages
    #   redirect_to root_path
    #   return
    # end

  #
  # def login_form
  # end
  #
  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end
  #
  def destroy
    if session[:user_id] == nil
      flash[:status] = :failure
      flash[:result_text] = "You are not logged in and therefore cannot log out"
    else
      session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    end
    redirect_to root_path
  end
end
