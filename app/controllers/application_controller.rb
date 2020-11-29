class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user
  before_action :require_login

  def render_404
    return render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def find_user
    #return user matching id from session variable
    return @login_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    if @login_user.nil?
      flash[:status] = :failure
      flash[:result_text] = "Please log in to view this page"
      redirect_to root_path
      return
    end
  end
end

