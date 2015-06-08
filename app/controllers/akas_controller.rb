class AkasController < ApplicationController
	skip_after_action :verify_policy_scoped

	def show
		@aka = Aka.find params[:id]
		render partial: "aka_template"
	end

	def index
		@akas = Aka.select([:id, :song_id, 'songs.song_name', :display_text, :search_text]).includes(:song).order 'songs.song_name', :display_text
	end

	def new
		@aka = Aka.new song_id: params[:song_id]
		authorize @aka
		render partial: "new"
	end

	def create
		aka = Aka.create aka_params
		authorize aka

		render json: {
			"what" => "created",
			"whatCreated" => "aka",
			"aka_id" => aka.id,
			"song_id" => aka.song_id,
		}
	end

	def update
		@aka = Aka.find(params[:id])
		authorize @aka
		@result = @aka.update_attributes params[:key] => params[:value]
	end

	def destroy
		authorize :aka
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
