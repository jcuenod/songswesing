class SongsController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def new
		@song = Song.new
		render partial: "song_popup"
	end

	def create
		@song = Song.create(song_params)
		render json: {
			"what" => "created", 
			"whatCreated" => "song", 
			"tag" => {"id" => @song.id, "label" => @song.song_name}
		}
	end

	def index
		@songs = Song.all
	end

	def list
	    render json: Song.autocomplete_data(params[:term])
	end
	def songdata
		@song_usage = Service.joins(:leader, :usages).group(:leader_name).where(:usages => {:song_id => params[:id]}).count
		@song = Song.find_by_id(params[:id])
		@colours = ["#E8D0A9", "#B7AFA3", "#C1DAD6", "#D5DAFA", "#ACD1E9", "#6D929B"]

		render json: render_to_string(partial: "songdata.json")
	end

	private
		def song_params
			params.require(:song).permit(:song_name, :license, :writers, :lyrics_url, :sof_number, :sample_url)
		end
end
