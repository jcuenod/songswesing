class ServiceTypesController < ApplicationController
	def index
		@service_types = policy_scope ServiceType.all
	end
	def new
		@service_type = ServiceType.new
		authorize @service_type, :create?
		render partial: "service_type_popup"
	end
	def create
		authorize ServiceType.new, :create?
		new_service_type_params = service_type_params
		new_service_type_params[:church_id] = current_user.church_id
		@service_type = ServiceType.create(new_service_type_params)
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
