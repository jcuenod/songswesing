class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  # POST /resource
  def create
    super do |resource|
      resource.church = Church.find_or_create_by(:church_name => params[:user][:church_attributes][:church_name])
    end

    if @user.persisted?
      UserMailer.send_notify_admin_of_new_users(@user).deliver
    end
  end

  protected
    # For custom field (church_attributes)
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:email, :password, :password_confirmation, :church_attributes => [ :church_name ])
      end
    end
end