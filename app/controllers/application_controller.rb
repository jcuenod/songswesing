class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #suggested pundit stuff
  after_action :verify_authorized, except: [:index, :data, :show]
  after_action :verify_policy_scoped, only: [:index, :data, :show]


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Sorry, it appears that you are not yet signed in"
    redirect_to(request.referrer || root_path)
  end
end
