class SongsController < ApplicationController
	skip_after_action :verify_policy_scoped
	skip_after_action :verify_authorized, :only => :list

	def new
		@song = Song.new
		authorize @song, :create?
		render partial: "new"
	end

	def create
		@song = Song.create(song_params)
		authorize @song

		params[:song][:akas_attributes].each_with_index do |a, index|
			@song.akas.new({:song_id => @song.id, :display_text => a[1][:display_text], :search_text => a[1][:display_text].gsub(/(?=\S)(\W)/,"").squeeze(" ").downcase})
			@song.save if index == 0
		end

		@song.save!

		render json: {
			"what" => "created",
			"whatCreated" => "song",
			"tag" => {"id" => @song.id, "label" => @song.song_name},
		}
	end

	def index
		@songs = Song.all.order :song_name
	end

	def list
	    render json: Song.autocomplete_data(params[:term])
	end
	def data
		@leader_usage_data = Service.joins(:leader, :usages).group(:leader_name).where(church_id: current_user.church_id, :usages => {:song_id => params[:id]}).count
		@song_frequency_data = Array.new(11, 0)
		@song_freq = Usage.joins(:service).where("date > ?", 1.year.ago).where(song_id: params[:id], :services => {church_id: current_user.church_id}).group("DATE_TRUNC('month', services.date)").count()
		@song_freq.map {|k, v| @song_frequency_data[k.strftime("%-m").to_i - 1] = v}
		@song_tags = Tag.all.map do |tag|
			st = SongTag.where(song_id: params[:id], tag_id: tag.id, church_id: current_user.church_id).limit 1
			{
				"id" => tag.id,
				"name" => tag.name,
				"value" => !st.blank?
			}
		end
		@song = Song.find_by_id(params[:id])
		@colours = ["#E8D0A9", "#B7AFA3", "#C1DAD6", "#D5DAFA", "#ACD1E9", "#6D929B"]

		render json: render_to_string(partial: "songdata.json")
	end

	def update
		@song = Song.find(params[:id])
		authorize @song
    	@result = @song.update_attributes params[:key] => params[:value]
	end

	private
		def song_params
			params.require(:song).permit(:song_name, :license, :writers, :lyrics_url, :sof_number, :sample_url, :ccli_number)
		end
end
