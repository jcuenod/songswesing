class AkasController < ApplicationController

	def show
		@aka = Aka.find params[:id]
		render partial: "aka_template"
	end

	def index
		@akas = Aka.includes(:song).order "songs.song_name", :display_text
	end

	def new
		@aka = Aka.new song_id: params[:song_id]
		render partial: "new"
	end

	def create
		aka = Aka.create aka_params

		render json: {
			"what" => "created",
			"whatCreated" => "aka",
			"aka_id" => aka.id,
			"song_id" => aka.song_id,
		}
	end

	def update
		if current_user.admin?
	    	@result = Aka.find(params[:id]).update_attributes params[:key] => params[:value]
	    	@aka = Aka.find(params[:id])
	    end
	end

	def destroy
		if Aka.destroy params[:id]
			render json: {
				"success" => true,
				"what" => "destroyed",
				"whatDestroyed" => "aka",
				"aka_id" => params[:id],
			}
		else
			render json: {
				"success" => false,
				"message" => "You can't delete this record: you would not be able to search for this song",
			}
		end
	end

	private
		def aka_params
			params.require(:aka).permit(:song_id, :display_text)
		end
end
