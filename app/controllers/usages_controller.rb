class UsagesController < ApplicationController
	def index
		@usages = Usage.all
	end
	def data
		@usage_data = Usage.limit(params[:limit]).group(:song_id, :song_name).joins(:song).order("count_all DESC").count
		render :partial => "usage_table"
	end
end
