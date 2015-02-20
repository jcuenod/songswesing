class ServicesController < ApplicationController
	before_filter :authenticate_user!
	def index
		useroffset = params[:offset].nil? ? 0 : params[:offset].to_i
		userlimit = params[:limit].nil? ? 100 : params[:limit].to_i
		#userlimit = userlimit > 100 ? 100 : userlimit

	 	@services = Service.limit(userlimit).offset(useroffset).where(church_id: current_user.church_id).order([:date => :desc, :service_type_id => :asc]).all
	 	@meh = params;
	 	render "index"
	end
	def new
		@leaders = Leader.where(church_id: current_user.church_id)
		@service_types = ServiceType.where(church_id: current_user.church_id)
		@service = Service.new
		@services = Service.where(church_id: current_user.church_id).limit(8).order([:date => :desc, :service_type_id => :asc]).all
		# flash.now[:notice] = "Viewing services for " + Church.find_by_id(current_user.church_id).church_name
	end
	def create
		unless params[:service][:songs].nil?
			new_service_params = service_params
			new_service_params[:church_id] = current_user.church_id
			@service = Service.create(new_service_params)
			params[:service][:songs].each do |song|
				Usage.create([
					:song_id => song,
					:service_id => @service.id
					])
			end
			render json: {
				"what" => "created", 
				"whatCreated" => "service", 
				"htmlOutput" => render_to_string(partial: "service_table_row")
			}
		else
			render json: params
		end
	end
	private
		def service_params
	      params.require(:service).permit(:date, :leader_id, :service_type_id)
	    end
		def usage_params
	      params.require(:service).permit(:date, :leader_id, :service_type_id)
	    end
end
