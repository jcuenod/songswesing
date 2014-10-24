class ServiceTypesController < ApplicationController
	def index
		@service_types = ServiceType.all
	end
	def new
		@service_type = ServiceType.new
		render partial: "service_type_popup"
	end
	def create
		@service_type = ServiceType.create(service_type_params)
		render json: {
			"what" => "created", 
			"whatCreated" => "service_type", 
			"htmlOutput" => render_to_string(partial: "options_for_service_type")
		}
	end

	private
		def service_type_params
	      params.require(:service_type).permit(:service_type, :weight)
	    end
end
