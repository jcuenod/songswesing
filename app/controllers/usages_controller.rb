class UsagesController < ApplicationController
	def index
		@usages = policy_scope(Usage.joins :service).select("MAX(services.date) as date", :song_name, :song_id, "count(song_id) as count_song_id").joins(:service, :song).group(:song_name, :song_id).order("count_song_id DESC")

    @song_tags = @usages.map do |usage|
      SongTag.where(church_id: current_user.church_id, song_id: usage.song_id).map do |st|
        Tag.find(st.tag_id).name
      end
    end
	end
	def data
		@usages = policy_scope(Usage.joins :service).limit(params[:limit]).select("MAX(services.date) as date", :song_name, :song_id, "count(song_id) as count_song_id").joins(:service, :song).group(:song_name, :song_id).order("count_song_id DESC")
		#@usages = Usage.limit(params[:limit]).group(:song_id, :song_name).joins(:song, :service).where(:services => {church_id: current_user.church_id}).order("count_song_id DESC").count :song_id
		render :partial => "usage_table"
	end
end