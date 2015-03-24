class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #suggested pundit stuff
  after_action :verify_authorized, except: [:index, :data, :show, :authindex], unless: :devise_controller?
  after_action :verify_policy_scoped, only: [:index, :data, :show], unless: :song_assist_controller?


  #rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "Sorry, it appears that you are not yet signed in"
    redirect_to(request.referrer || root_path)
  end

  def song_assist_controller?
    params[:controller] == 'song_assist'
  end
end
