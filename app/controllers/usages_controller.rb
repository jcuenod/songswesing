class UsagesController < ApplicationController
	def index
		@usages = Usage.select("MAX(services.date) as date", :song_name, :song_id, "count(song_id) as count_song_id").joins(:service, :song).group(:song_name, :song_id).order("count_song_id DESC")
	end
	def data
		@usages = Usage.limit(params[:limit]).select("MAX(services.date) as date", :song_name, :song_id, "count(song_id) as count_song_id").joins(:service, :song).group(:song_name, :song_id).order("count_song_id DESC")
		#@usages = Usage.limit(params[:limit]).group(:song_id, :song_name).joins(:song, :service).where(:services => {church_id: current_user.church_id}).order("count_song_id DESC").count :song_id
		render :partial => "usage_table"
	end
end