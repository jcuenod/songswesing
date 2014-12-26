class Users::RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    super do |resource|
      resource.church = Church.find_or_create_by(:church_name => params[:user][:church_attributes][:church_name])
    end
  end
end