class ServicesController < ApplicationController
	def index
	 	@services = Service.limit(8).order(:date).all
	end
	def new
		@leaders = Leader.all
		@service_types = ServiceType.all
		@service = Service.new
		@services = Service.limit(8).order(date: :desc).all
	end
	def create
		unless params[:service][:songs].nil?
			@service = Service.create(service_params)
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
