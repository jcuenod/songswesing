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
	def data
		usage_data = Usage.group(:song_id).joins(:service).where(:services => {leader_id: params[:id]}).count
		times_used = usage_data.inject({}) do |used, (k,v)|
			title = "Used " + v.to_s + " " + (v > 1 ? "time".pluralize : "time")
			if used[title].nil?
		    	used[title] = 1
		  	else
		    	used[title] += 1
		  	end
		  	used
		end
		return_data = Hash.new
		return_data["leader_name"] = Leader.find_by_id(params[:id]).leader_name
		return_data["chart_data"] = Hash[times_used.sort]
		render json: return_data
	end

	# def leaderdata
	# 	@leader_data = Service.joins(:usages).offset(10).limit(10).group(:leader_id).where(:leader_id => 1).count
	# end

	private
		def leader_params
	      params.require(:leader).permit(:leader_name)
	    end
end
