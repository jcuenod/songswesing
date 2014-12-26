class Users::RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    super do |resource|
      logger.debug "fish"
      logger.debug params[:user].inspect
      logger.debug "fingers"
      resource.church = Church.find_or_create_by(:church_name => params[:user][:church_attributes][:church_name])
    end
  end
end