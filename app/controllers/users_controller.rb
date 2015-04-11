class UsersController < ApplicationController
	def index
		if current_user.admin? || current_user.church_admin? || current_user.church_leader?
			@users = policy_scope(User.joins :church).order :church_id, "enabled DESC"
		else
			redirect_to root_path
		end
	end
  def destroy
    doomed_user = User.find params[:id]
    authorize doomed_user
    if doomed_user.destroy
      render json: {
        "success" => true,
        "what" => "destroyed",
        "whatDestroyed" => "user",
        "user_id" => params[:id],
      }
    else
      render json: {
        "success" => false,
        "message" => "You can't delete this record but you seem to have permission, so check the logs.",
      }
    end
  end

  def update
    updating_user = User.find params[:id]
    authorize updating_user
    if params[:key] == "new_role"
      updating_user.admin = params[:value] == "admin" && policy(:user).can_grant_admin?
      updating_user.church_admin = params[:value] == "church_admin"
      updating_user.church_leader = params[:value] == "church_leader"
      # if "guest", they'll all be false
    elsif params[:key] == "enabled"
      updating_user.enabled = params[:value] == "true"
    end
    render json: {
      "success" => updating_user.save
    }
  end
end