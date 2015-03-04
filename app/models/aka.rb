class Aka < ActiveRecord::Base
  belongs_to :song, :inverse_of => :akas
  before_save :update_search_text
  before_destroy :check_if_last_aka

  private
  	def update_search_text
  	  self.search_text = self.display_text.gsub(/(?=\S)(\W)/,"").squeeze(" ").downcase if display_text_changed?
  	end

  	def check_if_last_aka
  		return true if Aka.where(song_id: self.song_id).count > 1
  		errors.add :base, "Cannot delete the last aka"
  		false
  	end
end
