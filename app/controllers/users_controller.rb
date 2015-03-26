class UsersController < ApplicationController
	def index
		if current_user.admin? || current_user.church_admin?
			@users = policy_scope(User.joins :church).order :church_id
		else
			redirect_to root_path
		end
	end
end