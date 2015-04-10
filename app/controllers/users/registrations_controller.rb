class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  skip_before_action :verify_authenticity_token

  # POST /resource
  def create
    params[:user][:church_id] = Church.find_or_create_by(:church_name => params[:user][:church_attributes][:church_name]).id

    super

    if @user.persisted?
      UserMailer.send_notify_admin_of_new_users(@user).deliver_later
    end
  end

  protected
    # For custom field (church_attributes)
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        # :church_id is not going to actually arrive (:church_name will, as part of nested attributes), but we'll chuck it in there in our overridden #create method
        u.permit(:email, :password, :password_confirmation, :church_id)
      end
    end
end