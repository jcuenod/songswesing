class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]

  # POST /resource
  def create
    super
    resource.church = Church.find_or_create_by(church_name: sign_up_params[:church_attributes][:church_name])
  end

  protected

    def configure_sign_up_params
      devise_parameter_sanitizer.for(:sign_up) << [ church_attributes: [ :church_name ] ]
    end 

end