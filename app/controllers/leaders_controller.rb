class LeadersController < ApplicationController
	def index
		@leaders = Leader.all
	end
	def new
		@leader = Leader.new
		render partial: "leader_popup"
	end
	def create
		@leader = Leader.create(leader_params)
		render json: {
			"what" => "created", 
			"whatCreated" => "leader", 
			"htmlOutput" => render_to_string(partial: "options_for_leader")
		}
	end

	# def leaderdata
	# 	@leader_data = Service.joins(:usages).offset(10).limit(10).group(:leader_id).where(:leader_id => 1).count
	# end

	private
		def leader_params
	      params.require(:leader).permit(:leader_name)
	    end
end
