class LeadersController < ApplicationController
	def index
		@leaders = policy_scope Leader.all
	end
	def new
		@leader = Leader.new
		authorize @leader
		render partial: "leader_popup"
	end
	def create
		new_leader_params = leader_params
		new_leader_params[:church_id] = current_user.church_id
		@leader = Leader.create(new_leader_params)
		authorize @leader
		render json: {
			"what" => "created",
			"whatCreated" => "leader",
			"htmlOutput" => render_to_string(partial: "options_for_leader")
		}
	end
	def data
		usage_stats = policy_scope(Usage.group(:song_id).joins(:service)).where(:services => {leader_id: params[:id]}).count
		times_used = usage_stats.inject({}) do |used, (k,v)|
			title = "Used " + v.to_s + " " + (v > 1 ? "time".pluralize : "time")
			if used[title].nil?
		    	used[title] = 1
		  	else
		    	used[title] += 1
		  	end
		  	used
		end

		@usage_data = Usage.limit(5).group(:song_id, :song_name).joins(:song, :service).where(:services => {leader_id: params[:id]}).order("count_all DESC").count

		return_data = Hash.new
		return_data["leader_name"] = Leader.find_by_id(params[:id]).leader_name
		return_data["usage_table"] = render_to_string(partial: "usage_table")
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
