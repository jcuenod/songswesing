class SongsController < ApplicationController
	def new
		@song = Song.new
		render partial: "create"
	end

	def create
		@song = Song.create(song_params)
		params[:song][:akas_attributes].each do |a|
			Aka.create({:song_id => @song.id, :display_text => a[1][:display_text], :search_text => a[1][:display_text].gsub(/(?=\S)(\W)/,"").squeeze(" ").downcase})
		end

		render json: {
			"what" => "created", 
			"whatCreated" => "song", 
			"tag" => {"id" => @song.id, "label" => @song.song_name},
		}
	end

	def index
		@songs = Song.all
	end

	def list
	    render json: Song.autocomplete_data(params[:term])
	end
	def data
		@song_usage = Service.joins(:leader, :usages).group(:leader_name).where(church_id: current_user.church_id, :usages => {:song_id => params[:id]}).count
		@song = Song.find_by_id(params[:id])
		@colours = ["#E8D0A9", "#B7AFA3", "#C1DAD6", "#D5DAFA", "#ACD1E9", "#6D929B"]

		render json: render_to_string(partial: "songdata.json")
	end

	def update
		if current_user.admin?
	    	@r = Song.find(params[:id]).update_attribute(params[:key], params[:value])
	    end
	end

	private
		def song_params
			params.require(:song).permit(:song_name, :license, :writers, :lyrics_url, :sof_number, :sample_url, :ccli_number)
		end
end
