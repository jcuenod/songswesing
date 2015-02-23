class AkasController < ApplicationController
	def index
		@akas = Aka.joins(:song).order "songs.song_name"
	end

	def update
		if current_user.admin?
	    	@result = Aka.find(params[:id]).update_attributes params[:key] => params[:value]
	    	if params[:key] == "display_text"
	    		@result |= Aka.find(params[:id]).update_attributes :search_text => params[:value].gsub(/(?=\S)(\W)/,"").squeeze(" ").downcase
	    	end
	    	@aka = Aka.find(params[:id])
	    end
	end
end
