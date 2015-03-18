class ServicesController < ApplicationController
	before_filter :authenticate_user!
	def authindex
		if current_user.church_leader? || current_user.church_admin || current_user.admin?
			redirect_to action: "new"
		else
			redirect_to action: "index"
		end
	end
	def index
		#redirect_to action: "new" if current_user.church_leader? || current_user.church_admin? || current_user.admin?
		useroffset = params[:offset].nil? ? 0 : params[:offset].to_i
		userlimit = params[:limit].nil? ? 100 : params[:limit].to_i
		#userlimit = userlimit > 100 ? 100 : userlimit

	 	@services = policy_scope(Service).limit(userlimit).offset(useroffset).order([:date => :desc, :service_type_id => :asc]).all
	 	@meh = params;
	 	render "index"
	end
	def new
		@leaders = policy_scope(Leader.all).select(:id, :leader_name).order :leader_name
		@service_types = policy_scope(ServiceType.all).select(:id, :service_type).order :weight
		@service = Service.new
		authorize @service, :create?
		@services = policy_scope(Service.all).limit(8).order([:date => :desc, :service_type_id => :asc]).all
		# flash.now[:notice] = "Viewing services for " + Church.find_by_id(current_user.church_id).church_name
	end
	def create
		authorize :service
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
