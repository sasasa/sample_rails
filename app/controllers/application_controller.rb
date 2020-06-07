class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required
  before_action :set_locale

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def login_required
    redirect_to login_path unless current_user
  end

  def set_locale
    # ログインしていなければ日本語
    I18n.locale = current_user&.locale || :ja
  end
end
