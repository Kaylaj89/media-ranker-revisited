class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user

  def render_404
    return render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def find_user
    #return user matching id from session variable
    return @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end

