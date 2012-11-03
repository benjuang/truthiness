class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery
  before_filter :require_login
  before_filter :get_facebook_user
  helper_method :current_user_session, :current_user
  skip_before_filter :require_login, :only => [:index]
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to :controller=>'users', :action=>'new' # halts request cycle
    end
  end
  
  def get_facebook_user
    # @fb_user = current_facebook_user.fetch
  end
  
  def logged_in?
    !!current_user
  end
  
  ############################################
  ## PRIVATE
  ############################################
  private  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
  
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
      
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to "/new"
        return false
      end
    end
  
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to "/"
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  ## END PRIVATE
end
